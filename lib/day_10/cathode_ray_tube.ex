defmodule Adventofcode2022.Day10.CathodeRayTube do

  @crt_width  40
  @crt_height 6

  def crt_render(commands) do
    cycles = (1..@crt_width * @crt_height)

    rows = cycles
    |> Enum.chunk_every(40)
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> {index, row} end)
    |> Enum.into(%{})

    rows = Enum.reduce(cycles, rows, fn cycle, rows ->
      cycle_index = cycle - 1

      row_index = div(cycle_index, @crt_width)
      column_index = rem(cycle_index, @crt_width)

      row = Map.get(rows, row_index)

      x = calculate_register_x(commands, cycle) 

      sprite = [x-1, x, x+1]

      pixel = if column_index in sprite, do: "#", else: "."

      row_updated = List.replace_at(row, column_index, pixel)

      Map.put(rows, row_index, row_updated)
    end)

    output = rows
    |> Enum.map(fn {_k, row} -> Enum.join(row) end)
    |> Enum.join("\n")

    IO.puts("\n")
    IO.puts("--------------- 📺 CRT 📺 ---------------")
    IO.puts("\n")
    IO.puts(output)
  end

  def calculate_register_x(commands, cycles_to_run) do
    {x, _} = commands
    |> Enum.reduce_while({1, 0}, fn command, {x, cycles} ->
      cycles = cycles + command.cycles_to_complete

      if (cycles >= cycles_to_run) do
        {:halt, {x, cycles}}
      else
        {:cont, {x + command.x_value, cycles}}
      end
    end)

    x
  end

  def signal_strength(commands, cycles_to_run) do
    x = calculate_register_x(commands, cycles_to_run)

    cycles_to_run * x
  end

  def parse_commands(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line("noop"), do: new_command(1, 0)
  defp parse_line("addx " <> x), do: new_command(2, String.to_integer(x))

  defp new_command(cycles_to_complete, x_value) do
    %{cycles_to_complete: cycles_to_complete, x_value: x_value}
  end
end
