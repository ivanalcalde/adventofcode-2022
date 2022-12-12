defmodule Adventofcode2022.Day10.CathodeRayTube do
  def signal_strength(commands, cycles_to_run) do
    {x, _} = commands
    |> Enum.reduce_while({1, 0}, fn command, {x, cycles} ->
      cycles = cycles + command.cycles_to_complete

      if (cycles >= cycles_to_run) do
        {:halt, {x, cycles}}
      else
        {:cont, {x + command.x_value, cycles}}
      end
    end)

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
