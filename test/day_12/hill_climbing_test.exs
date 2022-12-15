defmodule Adventofcode2022.Day12.HillClimbingTest do
  use ExUnit.Case

  alias Adventofcode2022.Day12.HillClimbing

  test "foo" do
    input = """
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
      """

    input
    |> HillClimbing.parse()
    |> IO.inspect()
  end
end
