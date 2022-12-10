defmodule Adventofcode2022.Day09.RopeBridge do
  @type coord     :: {integer, integer}
  @type point     :: {coord, MapSet.t}
  @type visitor   :: atom
  @type direction :: :U | :D | :L | :R
  @type steps     :: non_neg_integer
  @type movement  :: {direction, steps}
  @type location  :: {visitor, coord}
  @type state     :: %{map: map, locations: list(location), movements: list(movement)}

  def init(input, visitors) do
    movements = parse_movements(input)

    {map, locations} = Enum.reduce(visitors, {%{}, []}, fn visitor, {map, locations} ->
      {map, _point, _visitor, locations} = add_visitor(map, {0, 0}, visitor, locations) 

      {map, locations}
    end)

    state = %{
      map: map,
      locations: locations,
      movements: movements,
      visitors: visitors
    }

    state
  end

  @spec count_positions(state, visitor) :: integer
  def count_positions(%{map: map, locations: _locations, movements: _movements}, visitor) do
    Enum.filter(map, fn {_k, {_coord, visitors}} ->
      visitor in visitors
    end)
    |> Enum.count()
  end

  def paint_movements(state, visitor) do
    {{min_x, _y}, _} = Enum.min_by(state.map, fn {{x, _y}, _} -> x end)
    {{max_x, _y}, _} = Enum.max_by(state.map, fn {{x, _y}, _} -> x end)
    {{_x, min_y}, _} = Enum.min_by(state.map, fn {{_x, y}, _} -> y end)
    {{_x, max_y}, _} = Enum.max_by(state.map, fn {{_x, y}, _} -> y end)

    rows = for y <- max_y..min_y do
      Enum.map(min_x..max_x, fn x ->
        coord = {x, y}

        mark = cond do
          coord == {0,0} -> "s"
          true ->
            case Map.get(state.map, coord) do
              {_coord, visitors} ->
                if visitor in visitors, do: "#", else: "."
              nil  -> "."
            end
        end

        mark
      end)
      |> Enum.join()
    end
    |> Enum.join("\n")

    IO.puts("          #{visitor}\n")
    IO.puts(rows)
  end

  @spec run(state, list(state)) :: list(state)
  def run(state, states \\ [])

  def run(%{map: _map, locations: _locations, movements: []}, states) do
    states
  end

  def run(state, states) do
    state = next_move(state)

    states = states ++ [state]

    run(state, states)
  end

  @spec next_move(state) :: state
  defp next_move(%{map: _map, locations: _locations, movements: []} = state) do
    state
  end

  defp next_move(%{map: map, locations: locations, movements: movements, visitors: visitors}) do
    [movement | movements] = movements

    coords = next_move_coords(locations, movement, visitors)

    {map, locations} = Enum.reduce(coords, {map, locations}, fn {visitor, coord}, {map, locations} ->
      {map, _point, _visitor, locations } = add_visitor(map, coord, visitor, locations)

      {map, locations}
    end)

    state = %{
      map: map,
      locations: locations,
      movements: movements,
      visitors: visitors
    }

    state
  end

  def next_move_coords(locations, movement, [visitor_head | visitors_tail]) do
    coord_head = Keyword.get(locations, visitor_head)
    new_coord_head = next_move_coord_head(coord_head, movement)

    coords = [{visitor_head, new_coord_head}]

    {_, coords} = Enum.reduce(visitors_tail, {new_coord_head, coords}, fn visitor, {coord_to_follow, coords} ->
      coord = Keyword.get(locations, visitor)
      new_coord = next_move_coord_tail(coord, coord_to_follow)
      coords = coords ++ [{visitor, new_coord}]

      {new_coord, coords}
    end)
    
    coords
  end

  def next_move_coord_head(coord, movement), do: move_coord(coord, movement)

  def next_move_coord_tail(coord_tail, coord_head) do
    {head_x, head_y} = coord_head
    {tail_x, tail_y} = coord_tail

    same_x? = head_x == tail_x
    same_y? = head_y == tail_y

    diff_x = head_x - tail_x
    diff_y = head_y - tail_y

    diff_x_2? = diff_x in [2, -2]
    diff_y_2? = diff_y in [2, -2]

    diff_x_1? = diff_x in [1, -1]
    diff_y_1? = diff_y in [1, -1]

    two_steps_directly_on_x? = same_y? and diff_x_2? 
    two_steps_directly_on_y? = same_x? and diff_y_2? 

    overlap? = same_x? and same_y?

    adjacent? = cond do
      same_x? and diff_y_1? -> true
      same_y? and diff_x_1? -> true
      diff_x_1? and diff_y_1? -> true
      true -> false
    end

    move_diagonal? = (diff_x_2? and diff_y_2?) or (diff_x_2? and diff_x_1?) or (diff_x_1? and diff_y_2?)

    move_on_x? = two_steps_directly_on_x? or diff_x_1?
    move_on_y? = two_steps_directly_on_y? or diff_y_1?

    direction_x = if diff_x < 0, do: :L, else: :R
    direction_y = if diff_y < 0, do: :D, else: :U

    cond do
      adjacent? -> coord_tail
      overlap?  -> coord_tail
      move_diagonal? ->
        coord_tail |> move_coord({direction_x, 1}) |> move_coord({direction_y, 1})
      move_on_y? ->
        coord_tail
        |> move_coord({direction_y, 1})
        |> next_move_coord_tail(coord_head)
      move_on_x? ->
        coord_tail
        |> move_coord({direction_x, 1})
        |> next_move_coord_tail(coord_head)
      true ->
        coord_tail
    end
  end

  @spec move_coord(coord, movement) :: coord
  def move_coord({x, y}, {direction, steps}) do
    case direction do
      :U -> {x, y+steps}
      :D -> {x, y-steps}
      :L -> {x-steps, y}
      :R -> {x+steps, y}
    end
  end

  @spec get_point(map, coord) :: { map, point }
  def get_point(map, coord) do
    point = Map.get(map, coord)
    if point do
      { map, point}
    else
      point = new_point(coord)
      map = Map.put(map, coord, point)

      {map, point}
    end
  end

  @spec add_visitor(map, coord, visitor, list(location)) :: { map, point, visitor, list(location)}
  def add_visitor(map, coord, visitor, locations \\ []) do
    {map, point} = get_point(map, coord)

    {_coord, visitors} = point

    point = {coord, MapSet.put(visitors, visitor)}

    map = Map.put(map, coord, point)

    locations = Keyword.put(locations, visitor, coord)

    {map, point, visitor, locations}
  end

  @spec new_point(coord) :: point
  defp new_point(coord), do: {coord, MapSet.new()}

  @spec parse_movements(String.t) :: list(movement)
  defp parse_movements(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [movement, steps] = String.split(line, " ")

      {String.to_atom(movement), String.to_integer(steps)}
    end)
    |> granulate_movements()
  end

  @spec granulate_movements(list(movement)) :: list(movement)
  defp granulate_movements(movements) do
    movements
    |> Enum.map(fn {direction, steps} ->
      Enum.map(1..steps, fn _ -> {direction, 1} end)
    end)
    |> List.flatten()
  end
end
