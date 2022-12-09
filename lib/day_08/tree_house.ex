defmodule Adventofcode2022.Day08.TreeHouse do
  def get_total_visible_trees(input) do
    {rows, cols} = get_rows_and_cols(input)

    rows_with_index = rows
    |> Enum.map(&mark_visible_trees/1)
    |> Enum.with_index()

    cols_with_index = cols
    |> Enum.map(&mark_visible_trees/1)
    |> Enum.with_index()

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
  
  def get_max_score(input) do
    {rows, cols} = get_rows_and_cols(input)

    rows_with_index = Enum.with_index(rows)
    cols_with_index = Enum.with_index(cols)

    next_coord = fn {row_index, col_index}, dir ->
      case dir do
        :top    -> {row_index - 1, col_index}
        :bottom -> {row_index + 1, col_index}
        :left   -> {row_index, col_index - 1}
        :right  -> {row_index, col_index + 1}
      end      
    end

    calculate_score = fn {row_index, col_index}, dir ->
      range = case dir do
        :top    -> row_index..0
        :bottom -> row_index..length(rows)-1
        :left   -> col_index..0
        :right  -> col_index..length(cols)-1
      end

      root_tree_height = get_tree_by_coords(rows, {row_index, col_index})

      {_, _, score} = Enum.reduce_while(range, {{row_index, col_index}, root_tree_height, 0}, fn _i, {coord, root_tree_height, score} ->
        coord = next_coord.(coord, dir)
        tree_height = get_tree_by_coords(rows, coord)

        cond do
          !tree_height                    -> {:halt, {nil, nil, score}}
          tree_height >= root_tree_height -> {:halt, {nil, nil, score + 1}}
          true ->  
            {:cont, {coord, root_tree_height, score + 1}}
        end
      end)

      score
    end

    scores = 
      for {_row, row_index} <- rows_with_index,
          {_col, col_index} <- cols_with_index do
        [
          calculate_score.({row_index, col_index}, :top),
          calculate_score.({row_index, col_index}, :bottom),
          calculate_score.({row_index, col_index}, :left),
          calculate_score.({row_index, col_index}, :right)
        ]
        |> Enum.reduce(1, fn score, acc -> 
          score * acc
        end)
      end

    Enum.max(scores)
  end

  defp get_tree_by_coords(rows, {row_index, col_index}) do
    cond do
      row_index < 0 -> nil
      col_index < 0 -> nil
      true ->
        rows
        |> Enum.at(row_index, [])
        |> Enum.at(col_index, nil)
    end

  end

  defp get_rows_and_cols(input) do
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

    rows = parse_int(rows_l2r)
    cols = parse_int(cols_t2b)

    {rows, cols}
  end

  defp print_trees(xs, cols_n) do
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

  defp mark_visible_trees(row_or_col) do
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
