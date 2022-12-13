defmodule Adventofcode2022.Day11.MonkeyInTheMiddle do
  @type item      :: integer
  @type operation :: %{
    operand_1: String.t,
    operand_2: String.t,
    operator: String.t
  }
  @type monkey :: %{
    items: list(item),
    operation: operation,
    test: fun,
    test_divisible_by: integer
  }

  def play(monkeys, rounds, fun_worry_level_after) do
    {conf, initial_state} = Enum.with_index(monkeys)
      |> Enum.reduce({%{}, %{}}, fn {monkey, index}, {conf, initial_state} ->
        conf = conf
        |> Map.put(index, Map.take(monkey, [:operation, :test]))

        initial_state = initial_state
        |> Map.put(
          index, 
          %{
            items: Map.get(monkey, :items),
            items_inspected: 0
          }
        )

        {conf, initial_state}
      end)

    states = Enum.reduce(1..rounds, initial_state, fn _round, state ->
      play_round(state, conf, fun_worry_level_after)
    end)

    states
  end

  def play_round(state, conf, fun_worry_level_after) do
    state
    |> Map.keys()
    |> Enum.sort()
    |> Enum.reduce(state, fn monkey_index, state ->
      play_round_by_monkey(state, conf, monkey_index, fun_worry_level_after)
    end)
  end

  def play_round_by_monkey(state, conf, monkey_index, fun_worry_level_after) do
    %{items: items} = Map.get(state, monkey_index)

    if items == [] do
      state
    else
      %{ operation: operation, test: test } = Map.get(conf, monkey_index)

      [item | items_tail] = items
      
      item = worry_level(item, operation) |> fun_worry_level_after.()

      throw_to_monkey_index = test.(item)

      state =
        state
        |> Map.update!(monkey_index, fn monkey ->
          monkey
          |> Map.put(:items, items_tail)
          |> Map.update!(:items_inspected, &(&1 + 1))
        end)
        |> Map.update!(throw_to_monkey_index, fn monkey ->
          monkey
          |> Map.update!(:items, &(&1 ++ [item]))
        end)

      play_round_by_monkey(state, conf, monkey_index, fun_worry_level_after)
    end
  end

  def sort_by_items_inspected(state) do
    Enum.sort_by(state, fn {_k, monkey} -> monkey.items_inspected end)
    |> Enum.reverse()
  end

  def monkey_business_level(state) do
    [
      {_, %{items_inspected: items_inspected_first}},
      {_, %{items_inspected: items_inspected_second}}
      | _tail
    ] = sort_by_items_inspected(state)

    items_inspected_first * items_inspected_second
  end

  def worry_level(item, %{operand_1: operand_1, operand_2: operand_2, operator: operator}) do
    operand_1 = parse_operand(operand_1, item)
    operand_2 = parse_operand(operand_2, item)

    case operator do
      "*" -> (operand_1 * operand_2)
      "+" -> (operand_1 + operand_2)
      _   -> item 
    end
  end

  def parse_operand("old", item), do: item
  def parse_operand(operand, _item), do: str_to_int(operand)

  @spec parse(String.t) :: list(monkey)
  def parse(input) do
    input
    |> String.split(~r/Monkey \d*:\n/, trim: true)
    |> Enum.map(&parse_monkey/1)
  end

  def parse_monkey(input) do
    [items, operation, test, test_truthy, test_falsy] =
      String.split(input, "  ", trim: true)

    items = parse_items(items)
    operation = parse_operation(operation)
    { test_fun, test_divisible_by } = parse_test(test, test_truthy, test_falsy)

    %{
      items: items,
      operation: operation,
      test: test_fun,
      test_divisible_by: test_divisible_by
    }
  end

  @spec parse_items(String.t) :: list(item)
  def parse_items("Starting items: " <> item_list) do
    item_list
    |> String.split(",", trim: true)
    |> Enum.map(&str_to_int/1)
  end

  @spec parse_operation(String.t) :: operation
  def parse_operation("Operation: new = " <> op) do
    %{
      "operand_1" => operand_1,
      "operand_2" => operand_2,
      "operator" => operator
    } = Regex.named_captures(~r/(?<operand_1>.*) (?<operator>.*) (?<operand_2>.*)\n/, op)

    %{
      operand_1: operand_1,
      operand_2: operand_2,
      operator: operator
    }
  end

  @spec parse_test(String.t, String.t, String.t) :: {fun, integer}
  def parse_test(
    "Test: divisible by " <> divisible_by,
    "If true: throw to monkey " <> monkey_number_if_true,
    "If false: throw to monkey " <> monkey_number_if_false
  ) do
    divisible_by = str_to_int(divisible_by)
    monkey_number_if_true = str_to_int(monkey_number_if_true)
    monkey_number_if_false = str_to_int(monkey_number_if_false)

    test_fun = 
      fn worry ->
        if rem(worry, divisible_by) == 0 do
          monkey_number_if_true
        else
          monkey_number_if_false
        end
      end

    {test_fun, divisible_by}
  end

  def str_to_int(str), do: str |> String.trim() |> String.to_integer()
end
