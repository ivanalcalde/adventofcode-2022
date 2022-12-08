defmodule Adventofcode2022.Day08.TreeHouse do
  def get_total_visible_trees(input) do
    rows_l2r = 
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    cols_t2b =
      rows_l2r
      |> Enum.reduce(%{}, fn row, acc ->
        Enum.with_index(row)
        |> Enum.reduce(acc, fn {tree, index}, acc -> 
          col = Map.get(acc, index, [])
          Map.put(acc, index, col ++ [tree])
        end)
      end)
      |> Enum.sort_by(fn {k, _col} -> k end)
      |> Enum.map(fn {_k, col} -> col end)

    rows =
      rows_l2r
      |> parse_int()
      |> Enum.with_index()
      |> Enum.map(&mark_visible_trees/1)

    cols =
      cols_t2b
      |> parse_int()
      |> Enum.with_index()
      |> Enum.map(&mark_visible_trees/1)

    rows_with_index = Enum.with_index(rows)
    cols_with_index = Enum.with_index(cols)

    for {row, row_index} <- rows_with_index,
        {col, col_index} <- cols_with_index do
          {height_r, visible_on_row?} = Enum.at(row, col_index)
          {_height_c, visible_on_col?} = Enum.at(col, row_index)
          
          visible? = visible_on_row? or visible_on_col?
          {height_r, visible?}
        end
        |> print_trees(length(cols))
        |> Enum.filter(fn {_height, visible?} -> visible? end)
        |> Enum.count()

  end

  def print_trees(xs, cols_n) do
    xs
    |> Enum.map(&visible_emoji/1)
    |> Enum.chunk_every(cols_n)
    |> Enum.map(fn row -> Enum.join(row) end)
    |> Enum.join("\n")
    |> (fn output ->
      """
      #{String.pad_leading("🌲 Treetop Tree House 🌲", cols_n) <> "\n"}
      #{output}
      #{"\n" <> String.pad_leading("🌲 Treetop Tree House 🌲", cols_n)}
      """
    end).()
    |> IO.puts()

    xs
  end

  def sort_by_index({_, index}), do: index

  def mark_visible_trees({ row_or_col, index }) do
    mark = fn row_or_col ->
      {_, marks} = Enum.reduce(row_or_col, {-1, []}, fn tree_height, {last_height, marks} ->
        next_height = max(tree_height, last_height)

        visible = last_height < tree_height

        {next_height, marks ++ [{tree_height, visible}]}
      end)

      marks
    end
    
    marks_from_side_a = mark.(row_or_col)
    marks_from_side_b = mark.(Enum.reverse(row_or_col)) |> Enum.reverse()

    Enum.zip(marks_from_side_a, marks_from_side_b)
    |> Enum.map(fn {{height, visible_from_side_a?}, {_h, visible_from_side_b?}} ->
      visible? = visible_from_side_a? or visible_from_side_b?
      {height, visible?}
    end)
  end

  defp visible_emoji({_height, visible?}) do
    # if visible?, do: "[🌲:#{height}]", else: "[❌:#{height}]"
    if visible?, do: "🌲", else: "❌"
  end

  defp parse_int(xss) do
    xss
    |> Enum.map(fn xs ->
      Enum.map(xs, &String.to_integer/1)
    end)
  end
end
