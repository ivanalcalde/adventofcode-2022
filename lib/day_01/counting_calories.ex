defmodule Adventofcode2022.Day01.CountingCalories do
  @input_file_path Path.join(__DIR__, "input2.txt")

  @type elf_number :: integer
  @type lines :: list(integer)
  @type total :: integer

  @spec get_elf_with_max_calories() :: {elf_number, total}
  def get_elf_with_max_calories() do
    get_totals_by_elf()
    |> Enum.max_by(fn {_, total} -> total end)
  end

  @spec get_elfs_with_more_calories(non_neg_integer) :: list({elf_number, total})
  def get_elfs_with_more_calories(take_n) do
    get_totals_by_elf()
    |> Enum.sort_by(fn {_, total} -> total end)
    |> Enum.reverse()
    |> Enum.take(take_n)
  end

  @spec get_total_of_elfs_with_more_calories(non_neg_integer) :: non_neg_integer
  def get_total_of_elfs_with_more_calories(take_n) do
    take_n
    |> get_elfs_with_more_calories()
    |> Enum.map(fn {_, total} -> total end)
    |> Enum.sum()
  end

  @spec get_elf_total_calories(elf_number) :: {:ok, total} | {:error, String.t}
  def get_elf_total_calories(n) do
    case Enum.find(get_totals_by_elf(), fn {elf_number, _} -> elf_number == n end) do
      nil -> {:error, "elf not found"}
      {_, total} -> {:ok, total}
    end
  end

  @spec get_totals_by_elf() :: list({elf_number, total})
  defp get_totals_by_elf() do
    get_logs()
    |> Enum.map(fn {elf_number, lines} ->
      {elf_number, Enum.sum(lines)}
    end)
  end

  @spec get_logs() :: list({elf_number, lines})
  defp get_logs() do
    {_, logs} = get_logs_by_elf()
    |> Enum.reduce({1, []}, fn elf_log, {elf_number, logs} ->
      {
        elf_number + 1,
        [{elf_number, to_lines(elf_log)} | logs]
      }
    end)

    logs
  end

  @spec to_lines(String.t) :: list(integer)
  defp to_lines(log) do
    String.split(log, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  @spec get_logs_by_elf() :: list(String.t)
  defp get_logs_by_elf() do
    read_input_file() |> String.split("\n\n", trim: true)
  end

  @spec read_input_file() :: String.t
  defp read_input_file() do
    File.read!(@input_file_path)
  end
end
