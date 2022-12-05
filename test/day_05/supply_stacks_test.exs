defmodule Adventofcode2022.Day05.SupplyStacksTest do
  use ExUnit.Case

  alias Adventofcode2022.Day05.SupplyStacks

  test "CRATE MOVER 9000 - returns the right message based on the crates placed on top of each stack (literal input)" do
    {stacks, move_commands} = """
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

    stacks = SupplyStacks.update_stacks_move_items(stacks, move_commands)

    assert SupplyStacks.get_code_message(stacks) == "CMZ"
  end

  test "CRATE MOVER 9000 - returns the right message based on the crates placed on top of each stack (file input)" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))
    {stacks, move_commands} = SupplyStacks.process_input(input)

    stacks = SupplyStacks.update_stacks_move_items(stacks, move_commands)

    assert SupplyStacks.get_code_message(stacks) == "FWSHSPJWM"
  end

  test "CRATE MOVER 9001 - returns the right message based on the crates placed on top of each stack (literal input)" do
    move_with_crate_mover_9001 = true
    {stacks, move_commands} = """
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

    stacks = SupplyStacks.update_stacks_move_items(stacks, move_commands, move_with_crate_mover_9001)

    assert SupplyStacks.get_code_message(stacks) == "MCD"
  end

  test "CRATE MOVER 9001 - returns the right message based on the crates placed on top of each stack (file input)" do
    move_with_crate_mover_9001 = true
    input = File.read!(Path.join(__DIR__, "./input.txt"))
    {stacks, move_commands} = SupplyStacks.process_input(input)

    stacks = SupplyStacks.update_stacks_move_items(stacks, move_commands, move_with_crate_mover_9001)

    assert SupplyStacks.get_code_message(stacks) == "PWPWHGFZS"
  end
end
