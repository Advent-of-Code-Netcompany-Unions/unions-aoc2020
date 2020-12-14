defmodule Day7 do
  @search_bag "shiny gold"

  @spec run(String.t()) :: {number, number}
  def run(file) do
    map = read_map_from_file(file)

    res1 = map |> part1()
    res2 = map |> part2()

    {res1, res2}
  end

  def read_map_from_file(file) do
    File.read!(file) |> String.split("\n", trim: false) |> read_map_from_lines(Map.new())
  end

  def read_map_from_lines([], map) do
    map
  end
  def read_map_from_lines([x | xs], map) do
    bags_contain = x |> String.split("bags contain", trim: true)

    bag_name = bags_contain |> Enum.at(0) |> String.trim()
    bag_list = bags_contain |> Enum.at(1)
                            |> String.split(",")
                            |> Enum.map(fn (str) -> str |> String.replace("bags", "") |> String.replace("bag", "") |> String.replace(".", "") |> String.trim end)
                            |> Enum.map(fn(item) -> cond do
                              String.match?(item, ~r/\d+ /) ->
                                number_str = item |> String.split(" ", trim: true) |> hd
                                {number_str |> String.to_integer, item |> String.replace(number_str <> " ", "")}
                              true -> {:empty}
                            end end)

    new_map = map |> Map.put(bag_name, bag_list)
    read_map_from_lines(xs, new_map)
  end

  def part1(map) do
    new_map = map |> Map.delete(@search_bag)
    part1(new_map, @search_bag)
  end
  defp part1(map, search) do
    traverse_unique_entries(map |> Map.keys, map, search, MapSet.new())
  end

  defp traverse_unique_entries([], _, _, found_bag_set) do
    found_bag_set |> MapSet.size()
  end
  defp traverse_unique_entries([x | xs], map, search, found_bag_set) do
    case contains_entry_recursive(map[x], map, search) do
      true -> traverse_unique_entries(xs, map, search, found_bag_set |> MapSet.put(x))
      false -> traverse_unique_entries(xs, map, search, found_bag_set)
    end
  end

  defp contains_entry_recursive([], _, _) do
    false
  end
  defp contains_entry_recursive([{:empty} | _], _, _) do
    false
  end
  defp contains_entry_recursive([{_, bag} | xs], map, search) do
    case bag == search do
      true -> true
      false -> contains_entry_recursive(map[bag], map, search) || contains_entry_recursive(xs, map, search)
    end
  end

  def part2(map) do
    part2(map, @search_bag)
  end
  defp part2(map, search) do
    count_bags(map[search], map, Map.new())
  end

  defp count_bags([], _map, _saved_values) do
    0
  end
  defp count_bags([{:empty}], _map, _saved_values) do
    0
  end
  defp count_bags([{amount, name} | xs], map, saved_values) do
    case saved_values |> Map.has_key?(name) do
      true -> saved_values[name]
      false ->
        a = amount + amount * count_bags(map[name], map, saved_values)
        b = count_bags(xs, map, saved_values)
        a + b
    end
  end

end
