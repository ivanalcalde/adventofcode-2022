defmodule Adventofcode2022.Day04.CampCleanup do
  @type input         :: String.t
  @type input_line    :: String.t
  @type pair          :: String.t
  @type area_id       :: non_neg_integer
  @type area_id_range :: Range.t
  @type assignment    :: {area_id_range, area_id_range}

  @spec find_assignments_with_full_overlap(list(assignment)) :: list(assignment)
  def find_assignments_with_full_overlap(assignments) do
    Enum.filter(assignments, & assignment_diff(&1) == [])
  end

  @spec find_assignments_with_overlap(list(assignment)) :: list(assignment)
  def find_assignments_with_overlap(assignments) do
    Enum.filter(assignments, fn assignment -> 
      area_ids = assignment_sum(assignment)
      area_ids_unique = Enum.uniq(area_ids)

      length(area_ids) != length(area_ids_unique)
    end)
  end

  @spec assignment_sum(assignment) :: list(area_id)
  def assignment_sum(assignment) do
    {area_ids_1, area_ids_2} = to_area_ids(assignment)

    area_ids_1 ++ area_ids_2
  end

  @spec assignment_diff(assignment) :: list(area_id)
  def assignment_diff(assignment) do
    {area_ids_1, area_ids_2} = to_area_ids(assignment)

    if length(area_ids_1) < length(area_ids_2) do
      area_ids_1 -- area_ids_2
    else
      area_ids_2 -- area_ids_1
    end
  end

  @spec to_area_ids(assignment) :: {list(area_id), list(area_id)}
  def to_area_ids({range1, range2}) do
    {Enum.to_list(range1), Enum.to_list(range2)}
  end

  @spec to_assignments(input) :: list(assignment)
  def to_assignments(input) do
    get_input_lines(input)
    |> Enum.map(&to_assignment/1)
  end

  @spec to_assignment(input_line) :: assignment
  defp to_assignment(input_line) do
    [pair1, pair2] = String.split(input_line, ",", trim: true)

    {to_range(pair1), to_range(pair2)}
  end

  @spec to_range(pair) :: area_id_range
  defp to_range(pair) do
    [from, to] = String.split(pair, "-", trim: true)

    String.to_integer(from)..String.to_integer(to)
  end

  @spec get_input_lines(input) :: list(input_line)
  defp get_input_lines(input) do
    String.split(input, "\n", trim: true)
  end
end
