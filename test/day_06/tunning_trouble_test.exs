defmodule Adventofcode2022.Day06.TunningTroubleTest do
  use ExUnit.Case

  alias Adventofcode2022.Day06.TunningTrouble

  test "returns the right start of packet marker" do
    assert TunningTrouble.get_start_of_packet_marker("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert TunningTrouble.get_start_of_packet_marker("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert TunningTrouble.get_start_of_packet_marker("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    assert TunningTrouble.get_start_of_packet_marker("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
  end

  test "returns the right start of packet marker (puzzle input)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    assert TunningTrouble.get_start_of_packet_marker(input) == 1833
  end
end
