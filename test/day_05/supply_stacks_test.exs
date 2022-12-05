defmodule Adventofcode2022.Day05.SupplyStacksTest do
  use ExUnit.Case

  alias Adventofcode2022.Day05.SupplyStacks

  test "returns the right message based on the crates placed on top of each stack (literal input)" do
    stacks = """
        [D]    
    [N] [C]    
    [Z] [M] [P]
     1   2   3 

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """
    |> SupplyStacks.process_input()

    assert SupplyStacks.get_code_message(stacks) == "CMZ"
  end

  test "returns the right message based on the crates placed on top of each stack (file input)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))
    stacks = SupplyStacks.process_input(input)

    assert SupplyStacks.get_code_message(stacks) == "FWSHSPJWM"
  end
end
