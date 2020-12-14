defmodule Day6 do

  @spec run(String.t()) :: {number, number}
  def run(file) do
    res1 = FileReaderUtility.file_to_multi_list_split_at_empty_line(file) |> part1()
    res2 = FileReaderUtility.file_to_map_list(file) |> part2()

    {res1, res2}
  end

  def part1(multi_list) do
    part1(multi_list, 0)
  end

  defp part1([], n) do
    n
  end
  defp part1([x | xs], n) do
    count = MapSet.new(x) |> MapSet.size()
    part1(xs, n + count)
  end

  def part2(map_list) do
    List.foldl(map_list, 0, fn (elem, acc) -> acc + count_matches_in_map_list(elem) end)
  end

  defp count_matches_in_map_list([head | tail]) do
    Enum.reduce(Map.values(head), 0, fn (item, acc) -> acc + (all_match_in_map_list(tail, item) && 1 || 0) end)
  end

  defp all_match_in_map_list([], _) do
    true
  end
  defp all_match_in_map_list([x | xs], element) do
    case Enum.member?(Map.values(x), element) do
      true -> all_match_in_map_list(xs, element)
      false -> false
    end
  end

end
