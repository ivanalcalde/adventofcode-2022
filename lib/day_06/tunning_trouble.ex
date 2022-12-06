defmodule Adventofcode2022.Day06.TunningTrouble do

  def get_start_of_packet_marker(input), do: get_marker(input, 4)
  def get_start_of_message_marker(input), do: get_marker(input, 14)

  defp get_marker(input, chunks_size) do
    buffer = String.graphemes(input)
    
    {_char, index} = buffer
    |> Enum.with_index
    |> make_chunks_by(chunks_size)
    |> Enum.find(&all_chars_different?/1)
    |> List.last()

    index + 1
  end

  defp all_chars_different?(chars_with_index) do
    chars = Enum.map(chars_with_index, fn {char, _index} -> char end)

    length(chars) == length(Enum.uniq(chars))
  end

  defp make_chunks_by(xs, chunk_size, chunks \\ [])

  defp make_chunks_by(xs, chunk_size, chunks) when length(xs) == chunk_size do
    chunks ++ [xs]
  end

  defp make_chunks_by(xs, chunk_size, chunks) do
    chunk = Enum.slice(xs, 0, chunk_size)

    chunks = chunks ++ [chunk]

    [_head | tail] = xs

    make_chunks_by(tail, chunk_size, chunks)
  end
end
