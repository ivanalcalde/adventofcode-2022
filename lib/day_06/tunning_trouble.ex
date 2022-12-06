defmodule Adventofcode2022.Day06.TunningTrouble do
  def get_start_of_packet_marker(input) do
    buffer = String.graphemes(input)
    
    {_char, index} = buffer
    |> Enum.with_index
    |> make_chunks_by_4()
    |> Enum.find(&all_chars_different?/1)
    |> List.last()

    index + 1
  end

  def all_chars_different?(chars_with_index) do
    chars = Enum.map(chars_with_index, fn {char, _index} -> char end)

    length(chars) == length(Enum.uniq(chars))
  end

  def make_chunks_by_4(xs, chunks \\ [])

  def make_chunks_by_4([_a, _b, _c, _d] = chunk, chunks) do
    chunks ++ [chunk]
  end

  def make_chunks_by_4(xs, chunks) do
    chunk = Enum.slice(xs, 0, 4)

    chunks = chunks ++ [chunk]

    [_head | tail] = xs

    make_chunks_by_4(tail, chunks)
  end
end
