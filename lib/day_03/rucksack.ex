defmodule Adventofcode2022.Day03.Rucksack do
  @type input        :: String.t
  @type input_line   :: String.t
  @type priority     :: non_neg_integer
  @type rucksack     :: String.t
  @type item         :: String.t
  @type priority_map :: %{item => priority}
  @type elf_group    :: {input_line, input_line, input_line}        

  @items ~w(
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
  )

  @spec get_input_priority_total(input) :: priority
  def get_input_priority_total(input) do
    input
    |> get_priority_maps()
    |> Enum.map(&get_priority_map_total/1) 
    |> Enum.sum()
  end

  @spec get_priority_map_total(priority_map) :: priority
  def get_priority_map_total(priority_map) do
    priority_map
    |> Map.values()
    |> Enum.sum()
  end

  @spec get_priority_maps(input) :: list(priority_map)
  def get_priority_maps(input) do
    get_input_lines(input)
    |> Enum.map(&get_rucksacks/1)
    |> Enum.map(fn {r1, r2} -> get_items_in_both_rucksacks(r1, r2) end)
  end

  @spec get_priority_badges_total(input) :: priority
  def get_priority_badges_total(input) do
    get_badges(input)
    |> Enum.map(&get_item_priority/1)
    |> Enum.sum()
  end

  @spec get_badges(input) :: list(item)
  def get_badges(input) do
    input
    |> get_elf_groups()
    |> Enum.map(&find_elf_group_badge/1)
  end

  @spec get_input_lines(input) :: list(input_line)
  def get_input_lines(input), do: String.split(input, "\n", trim: true)

  @spec get_elf_groups(input) :: list(elf_group)
  def get_elf_groups(input) do
    get_input_lines(input)
    |> Enum.chunk_every(3)
    |> Enum.map(&List.to_tuple/1)
  end

  @spec find_elf_group_badge(elf_group) :: item
  def find_elf_group_badge({l1, l2, l3}) do
    l1
    |> get_items()
    |> Enum.filter(&in_rucksack?(&1, l2))
    |> Enum.filter(&in_rucksack?(&1, l3))
    |> hd()
  end

  @spec get_items_in_both_rucksacks(rucksack, rucksack) :: priority_map
  def get_items_in_both_rucksacks(rucksack1, rucksack2) do
    rucksack1
    |> get_items()
    |> Enum.filter(&in_rucksack?(&1, rucksack2))
    |> Enum.uniq()
    |> to_priority_map()
  end

  @spec to_priority_map(list(item)) :: priority_map
  def to_priority_map(items) do
    Enum.into(items, %{}, &{&1, get_item_priority(&1)})
  end

  @spec get_items(input_line) :: list(rucksack)
  def get_items(str), do: String.graphemes(str)

  @spec get_item_priority(item) :: priority
  def get_item_priority(item) do
    Enum.find_index(@items, & &1 == item) + 1
  end

  @spec get_rucksacks(input_line) :: {rucksack, rucksack}
  def get_rucksacks(input_line) do
    items = get_items(input_line)
    len = length(items)
    middle = div(len, 2)

    rucksack1 = Enum.slice(items, 0, middle)
    rucksack2 = Enum.slice(items, middle, len)

    {Enum.join(rucksack1), Enum.join(rucksack2)}
  end

  @spec in_rucksack?(item, rucksack) :: boolean
  def in_rucksack?(item, rucksack), do: item in get_items(rucksack)
end
