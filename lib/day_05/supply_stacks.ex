defmodule Adventofcode2022.Day05.SupplyStacks do
  @type input         :: String.t
  @type item          :: String.t
  @type stack         :: list(item)
  @type stack_id      :: atom
  @type move_command  :: {qty :: non_neg_integer, from :: stack_id, to :: stack_id}
  @type stacks        :: [stack_id: stack]
  @type move_commands :: list(move_command)

  @spec process_input(input) :: stacks
  def process_input(input) do
    {stacks, move_commands} = parse_input(input)

    update_stacks_move_items(stacks, move_commands)
  end

  @spec get_code_message(stacks) :: String.t
  def get_code_message(stacks) do
    stacks
    |> Enum.sort_by(fn {stack_id, _items} -> stack_id end)
    |> Enum.map(fn {_stack_id, items} -> List.first(items) || "" end)
    |> Enum.join()
  end

  @spec parse_input(input) :: {stacks, move_commands}
  def parse_input(input) do
    [s, c] = String.split(input, "\n\n", trim: true)

    {_, stacks_lines} = String.split(s, "\n") |> List.pop_at(-1)

    stacks = stacks_lines
    |> Enum.map(&parse_stack_input_line/1)
    |> Enum.map(fn items -> 
        items
        |> Enum.map(&parse_stack_item/1)
        |> Enum.with_index(fn item, index -> 
          stack_id = index + 1

          {stack_id, item}
        end)
    end)
    |> Enum.reverse()
    |> List.flatten()
    |> Enum.reduce([], fn {stack_id, item}, stacks ->
      update_stacks_put_item(stacks, stack_id, item)
    end)

    move_commands = String.split(c, "\n", trim: true)
    |> Enum.map(&parse_move_command/1)

    {
      stacks,
      move_commands,
    }
  end

  @spec update_stacks_put_item(stacks, non_neg_integer, item) :: stacks
  def update_stacks_put_item(stacks, stack_id, item) when is_integer(stack_id) do
    update_stacks_put_item(stacks, :"#{stack_id}", item)
  end

  @spec update_stacks_put_item(stacks, stack_id, item) :: stacks
  def update_stacks_put_item(stacks, stack_id, item) do
    stack = Keyword.get(stacks, stack_id, [])

    if item == nil do
      stacks
    else
      Keyword.put(stacks, stack_id, [item | stack])
    end
  end

  def update_stacks_move_items(stacks, move_commands) do
    Enum.reduce(move_commands, stacks, fn {qty, from_id, to_id}, stacks ->
      from_stack = Keyword.get(stacks, from_id, [])
      to_stack = Keyword.get(stacks, to_id, [])

      {items_to_move, from_stack} = Enum.split(from_stack, qty)

      stacks
      |> Keyword.put(from_id, from_stack)
      |> Keyword.put(to_id, Enum.reverse(items_to_move) ++ to_stack)
    end)
  end

  @spec parse_stack_input_line(String.t, list(String.t)) :: list(String.t)
  def parse_stack_input_line(line, parts \\ []) do
    if String.length(line) < 4 do
      parts ++ [line]
    else
      {item_chunk, rest} = String.split_at(line, 4)
      parse_stack_input_line(rest, parts ++ [item_chunk])
    end
  end

  @spec parse_stack_item(String.t) :: item | nil
  def parse_stack_item(stack_item) do
    case Regex.named_captures(~r/\[(?<item>.+)\]/, stack_item) do
      %{"item" => item} -> item
      nil -> nil
    end
  end

  @spec parse_move_command(String.t) :: move_command
  def parse_move_command(command) do
    %{
      "qty"  => qty,
      "from" => from,
      "to"   => to
    } = Regex.named_captures(~r/move\s(?<qty>.+)\sfrom\s(?<from>.+)\sto\s(?<to>.+)/, command)

    {String.to_integer(qty), String.to_atom(from), String.to_atom(to)}
  end
end
