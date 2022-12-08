defmodule Adventofcode2022.Day08.TreeHouseTest do
  use ExUnit.Case

  alias Adventofcode2022.Day08.TreeHouse

  test "returns the total of visible trees" do
    input = """
      30373
      25512
      65332
      33549
      35390
      """
    assert TreeHouse.get_total_visible_trees(input) == 21
  end

  test "returns the total of visible trees (input file)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    assert TreeHouse.get_total_visible_trees(input) == 1792
  end
end
