defmodule Adventofcode2022.Day03.RucksackTest do
  use ExUnit.Case

  alias Adventofcode2022.Day03.Rucksack

  test "get the priority map of each input line" do
    result =
      """
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
      """
      |> Rucksack.process_input()

    assert result == [
      %{"p" => 16}, %{"L" => 38}, %{"P" => 42}, %{"v" => 22}, %{"t" => 20}, %{"s" => 19}
    ]
  end

  test "get the priority total of the input" do
    result =
      """
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
      """
      |> Rucksack.get_input_priority_total()

    assert result == 157
  end

  test "get the priority total of the input file" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    assert Rucksack.get_input_priority_total(input) == 7701
  end
end
