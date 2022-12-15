defmodule Adventofcode2022.Day12.HillClimbing do
  def parse(input) do
    rows = input
      |> String.split("\n", trim: true)
      |> Enum.map(&to_charlist/1) 
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()

    map = for {row, row_index} <- rows,
              {height, col_index} <- row,
              into: %{} do
      {[row_index, col_index], height}
    end

    {start_pos, _} = Enum.find(map, fn {_, height} -> height == ?S end)
    {finish_pos, _} = Enum.find(map, fn {_, height} -> height == ?E end)

    map =
      map
      |> Map.put(start_pos, ?a)
      |> Map.put(finish_pos, ?z)

    itinerary = Enum.map(map, fn {pos, _height} = map_entry ->
      opts = itinerary_opts(map_entry, map)

      {pos, opts}
    end)
    |> Enum.into(%{})

    %{
      start_pos: start_pos,
      finish_pos: finish_pos,
      map: map,
      itinerary: itinerary,
      itinerary_backwards: itinerary_backwards(itinerary)
    }
  end

  defp itinerary_opts({[row, col], height}, map) do
    max_index_by = fn map, fun_max_by ->
      map |> Map.keys() |> Enum.max_by(fun_max_by)
    end

    col_max_index = max_index_by.(map, fn [_row, col] -> col end) |> Enum.at(1)
    row_max_index = max_index_by.(map, fn [row, _col] -> row end) |> Enum.at(0)

    opts =
      [[-1, 0], [1, 0], [0, -1], [0, 1]]
      |> Enum.map(fn [row_inc, col_inc] -> [row + row_inc, col + col_inc] end)
      |> Enum.filter(fn [row, col] ->
        row >= 0 and row <= row_max_index and col >= 0 and col <= col_max_index
      end)
      |> Enum.filter(fn pos -> map[pos] <= height + 1 end)

    opts
  end

  def itinerary_backwards(itinerary) do
    for {pos, pos_opts} <- itinerary,
        pos_opt <- pos_opts,
        reduce: [] do
      acc ->
        [{pos, pos_opt} | acc]
    end
    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
  end



















end
