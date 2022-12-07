defmodule Adventofcode2022.Day07.NoSpaceLeftOnDevice do
  def parse(input) do
    lines = String.split(input, "\n", trim: true)

    {_, dirs} = Enum.reduce(lines, {"/", %{}}, fn line, {current_dir, dirs} = acc ->
      case parse_line(line) do
        {:cd, dir} -> 
          new_dir = cd_dir(current_dir, dir)

          {new_dir, add_dir(dirs, new_dir)}
        {:file, file} ->
          {current_dir, add_file(dirs, current_dir, file)}
        nil -> acc
      end
    end)

    dirs
  end

  def list_dirs_with_total_size(dirs) do
    dirs
    |> list_dirs_with_files()
    |> Map.to_list()
    |> Enum.map(fn {dir, files} -> {dir, get_total_size(files)} end)
    |> Enum.into(%{})
  end

  def list_dirs_with_files(dirs) do
    dirs
    |> list_dirs()
    |> Enum.map(& {&1, files_by_dir(dirs, &1)})
    |> Enum.into(%{})
  end

  def get_total_size(files) do
    files
    |> Enum.map(fn {_file_name, file_size} -> file_size end)
    |> Enum.sum()
  end

  def list_dirs(dirs), do: Map.keys(dirs)

  def files_by_dir(dirs, dir) do
    Map.filter(dirs, fn {k, _v} -> String.starts_with?(k, dir) end)
    |> Map.values()
    |> List.flatten()
  end

  def parse_line(line) do
    cond do
      cd?(line) -> {:cd, get_cd_dir(line)}
      file?(line) -> {:file, get_file(line)}
      true -> nil  
    end
  end

  def add_dir(dirs, dir), do: add_file(dirs, dir, nil)

  def add_file(dirs, dir, file) do
    files = Map.get(dirs, dir, [])

    if file do
      Map.put(
        dirs,
        dir,
        Enum.uniq([file | files])
      )
    else
      Map.put(dirs, dir, files)
    end
  end

  def cd_dir("/", ".."), do: "/"
  def cd_dir("/", "/"), do: "/"

  def cd_dir(current_dir, "..") do
    {_, dirs} = current_dir
    |> String.split("/", trim: true)
    |> List.pop_at(-1)

    "/#{Enum.join(dirs, "/")}"
  end

  def cd_dir(current_dir, dir) do
    dirs = String.split(current_dir, "/", trim: true) ++ [dir] 

    "/#{Enum.join(dirs, "/")}"
  end

  def cd?(str), do: String.match?(str, ~r/^\$ cd /)
  def get_cd_dir(str) do
    %{"dir" => dir} = Regex.named_captures(~r/^\$ cd (?<dir>.+)/, str)

    dir
  end

  def file?(str), do: String.match?(str, ~r/^\d+ .+/)
  def get_file(str) do
    %{"file_size" => file_size, "file_name" => file_name} =
      Regex.named_captures(~r/^(?<file_size>\d+) (?<file_name>.+)/, str)

    {file_name, String.to_integer(file_size)}
  end
end
