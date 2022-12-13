defmodule Adventofcode2022.Day11.MonkeyInTheMiddleTest do
  use ExUnit.Case

  alias Adventofcode2022.Day11.MonkeyInTheMiddle

  # @tag :skip
  # @tag timeout: :infinity
  test "foo" do
    input = File.read!(Path.join(__DIR__, "./input_1.txt"))

    MonkeyInTheMiddle.parse(input)
    |> MonkeyInTheMiddle.play(10000, fn worry ->
      big_prime = 23 * 19 * 17 * 13

      rem(worry, big_prime)
    end)
    |> IO.inspect()
  end

  # @tag :skip
  test "returns monkey business level (part 1 - input 1)" do
    input = File.read!(Path.join(__DIR__, "./input_1.txt"))

    assert MonkeyInTheMiddle.parse(input)
    |> MonkeyInTheMiddle.play(20, &(div(&1, 3)))
    |> MonkeyInTheMiddle.monkey_business_level() == 10605
  end

  # @tag :skip
  test "returns monkey business level (part 1 - input 2)" do
    input = File.read!(Path.join(__DIR__, "./input_2.txt"))

    assert MonkeyInTheMiddle.parse(input)
    |> MonkeyInTheMiddle.play(20, &(div(&1, 3)))
    |> MonkeyInTheMiddle.monkey_business_level() == 55216
  end

  # @tag :skip
  test "returns monkey business level (part 2 - input 1)" do
    input = File.read!(Path.join(__DIR__, "./input_1.txt"))

    monkeys = MonkeyInTheMiddle.parse(input)
    factor = monkeys |> Enum.map(& &1.test_divisible_by) |> Enum.product()

    assert MonkeyInTheMiddle.parse(input)
    |> MonkeyInTheMiddle.play(10000, & rem(&1, factor))
    |> MonkeyInTheMiddle.monkey_business_level() == 2713310158
  end

  test "returns monkey business level (part 2 - input 2)" do
    input = File.read!(Path.join(__DIR__, "./input_2.txt"))

    monkeys = MonkeyInTheMiddle.parse(input)
    factor = monkeys |> Enum.map(& &1.test_divisible_by) |> Enum.product()

    assert MonkeyInTheMiddle.parse(input)
    |> MonkeyInTheMiddle.play(10000, & rem(&1, factor))
    |> MonkeyInTheMiddle.monkey_business_level() == 12848882750
  end
end
