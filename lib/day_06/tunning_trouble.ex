defmodule Adventofcode2022.Day06.TunningTrouble do

  def get_start_of_packet_marker(input), do: get_marker(input, 4)
  def get_start_of_message_marker(input), do: get_marker(input, 14)

  def get_marker(input, chunks_size) do
    buffer = String.graphemes(input)

    start_marker_index = 
      0..length(buffer)-1
      |> Enum.take_while(fn index ->
        not (Enum.slice(buffer, index, chunks_size) |> all_chars_different?())
      end)
      |> List.last()

    if start_marker_index == nil do
      nil
    else
      start_marker_index + 1 + chunks_size
    end
  end

  defp all_chars_different?(chars) do
    length(chars) == length(Enum.uniq(chars))
  end
end
