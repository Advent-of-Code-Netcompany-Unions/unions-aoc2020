defmodule Day10 do

  @spec run(String.t()) :: {number, number}
  def run(file) do
    lines = file |> FileReaderUtility.file_to_integer_list()

    res1 = lines |> part1()
    res2 = lines |> part2()

    {res1, res2}
  end

  def part1(lines) do
    res_map = lines |> get_devices_list() |> part1_get_diff_map()
    Map.get(res_map, 1, 0) * Map.get(res_map, 3, 0)
  end

  defp get_devices_list(lines) do
    sorted_integer_list = lines |> Enum.sort()
    device_output = Enum.max(sorted_integer_list) + 3
    sorted_integer_list ++ [device_output]
  end

  def part1_get_diff_map(sorted_integer_list) do
    {_, map} = List.foldl(
      sorted_integer_list,
      {0, Map.new()},
      fn (item, {previous, map}) ->
        diff = item - previous
        {item, map |> Map.update(diff, 1, fn (x) -> x + 1 end)}
      end)
    map
  end

  def part2(lines) do
    lines |> get_devices_list() |> part2_get_combinations()
  end

  def part2_get_combinations(sorted_integer_list) do
    part2_get_combinations([0 | sorted_integer_list], 1, Map.new())
  end

  defp part2_get_combinations(lst, index, cache_map) when index >= length(lst) do
    cache_map |> Map.get(index - 1)
  end
  defp part2_get_combinations(lst, index, cache_map) when index < length(lst) do
    value = cache_map |> Map.get(index - 1, 1)
    value = if index > 1 and Enum.at(lst, index) - Enum.at(lst, index - 2) <= 3, do: value + Map.get(cache_map, index - 2, 1), else: value
    value = if index > 2 and Enum.at(lst, index) - Enum.at(lst, index - 3) <= 3, do: value + Map.get(cache_map, index - 3, 1), else: value
    part2_get_combinations(lst, index + 1, cache_map |> Map.put(index, value))
  end

end
