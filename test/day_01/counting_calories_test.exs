defmodule Adventofcode2022.Day01.CountingCaloriesTest do
  use ExUnit.Case

  alias Adventofcode2022.Day01.CountingCalories

  test "returns the elf with max calories" do
    assert CountingCalories.get_elf_with_max_calories() == {6, 69281}
  end

  test "returns the 3 elfs with more calories" do
    assert CountingCalories.get_elfs_with_more_calories(3) == [
      {6, 69281},
      {154, 67653},
      {180, 64590}
    ]
  end

  test "returns the total of the 3 elfs with more calories" do
    assert CountingCalories.get_total_of_elfs_with_more_calories(3) == 201524
  end

  test "returns the total calories of the elf number passed" do
    assert CountingCalories.get_elf_total_calories(4) == {:ok, 22456}
  end

  test "returns an error when the elf number does not exist" do
    assert CountingCalories.get_elf_total_calories(1000) == {:error, "elf not found"}
  end
end
