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

  test "returns the right start of message marker" do
    assert TunningTrouble.get_start_of_message_marker("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
    assert TunningTrouble.get_start_of_message_marker("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    assert TunningTrouble.get_start_of_message_marker("nppdvjthqldpwncqszvftbrmjlhg") == 23
    assert TunningTrouble.get_start_of_message_marker("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
    assert TunningTrouble.get_start_of_message_marker("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
  end

  test "returns the right start of message marker (puzzle input)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    assert TunningTrouble.get_start_of_message_marker(input) == 3425
  end
end
