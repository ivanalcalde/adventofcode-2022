defmodule Adventofcode2022.Day04.CampCleanupTest do
  use ExUnit.Case

  alias Adventofcode2022.Day04.CampCleanup

  test "returns the right amount of pairs that full overlap from the input" do
    assert """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """    
    |> CampCleanup.to_assignments()
    |> CampCleanup.find_assignments_with_full_overlap()
    |> length() == 2
  end

  test "returns the right amount of pairs that overlap from the input" do
    assert """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """    
    |> CampCleanup.to_assignments()
    |> CampCleanup.find_assignments_with_overlap()
    |> length() == 4
  end

  test "returns the right amount of pairs that full overlap from the input file" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    assert input    
    |> CampCleanup.to_assignments()
    |> CampCleanup.find_assignments_with_full_overlap()
    |> length() == 526
  end

  test "returns the right amount of pairs that overlap from the input file" do
    input = File.read!(Path.join(__DIR__, "./input.txt"))

    assert input    
    |> CampCleanup.to_assignments()
    |> CampCleanup.find_assignments_with_overlap()
    |> length() == 886
  end
end
