defmodule Adventofcode2022.Day07.NoSpaceLeftOnDeviceTest do
  use ExUnit.Case

  alias Adventofcode2022.Day07.NoSpaceLeftOnDevice

  test "puzzle part 1" do
    input = """
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
      """

    result = NoSpaceLeftOnDevice.parse(input)
    |> NoSpaceLeftOnDevice.list_dirs_with_total_size()
    |> Map.filter(fn {_k, v} -> v <= 100000 end)
    |> Map.values()
    |> Enum.sum()

    assert result == 95437
  end

  test "puzzle part 1 (input file)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))
  
    result = NoSpaceLeftOnDevice.parse(input)
    |> NoSpaceLeftOnDevice.list_dirs_with_total_size()
    |> Map.filter(fn {_k, v} -> v <= 100000 end)
    |> Map.values()
    |> Enum.sum()

    assert result == 1306611
  end
end
