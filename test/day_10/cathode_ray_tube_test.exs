defmodule Adventofcode2022.Day10.CathodeRayTubeTest do
  use ExUnit.Case

  alias Adventofcode2022.Day10.CathodeRayTube

  # @tag :skip
  test "calculates the signal strength (input_1.txt)" do
    input = File.read!(Path.join(__DIR__, "./input_1.txt"))

    commands = CathodeRayTube.parse_commands(input)

    signals = [20, 60, 100, 140, 180, 220]
    |> Enum.map(& CathodeRayTube.signal_strength(commands, &1)) 

    assert signals == [420, 1140, 1800, 2940, 2880, 3960]
    assert signals |> Enum.sum() == 13140
  end

  # @tag :skip
  test "calculates the signal strength (input_2.txt)" do
    input = File.read!(Path.join(__DIR__, "./input_2.txt"))

    commands = CathodeRayTube.parse_commands(input)

    signals = [20, 60, 100, 140, 180, 220]
    |> Enum.map(& CathodeRayTube.signal_strength(commands, &1)) 

    assert signals |> Enum.sum() == 13480
  end
end
