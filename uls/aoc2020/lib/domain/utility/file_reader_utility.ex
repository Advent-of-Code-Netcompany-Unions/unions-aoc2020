defmodule FileReaderUtility do

  def file_to_lines(file) do
    File.read!(file) |> String.split("\n", trim: false)
  end

  def file_to_multi_list(file) do
    file_to_lines(file) |> lines_to_multi_list()
  end

  defp lines_to_multi_list(lines) do
    lines_to_multi_list(lines, [], [])
  end
  defp lines_to_multi_list([], current_list, result) do
    result ++ [current_list]
  end
  defp lines_to_multi_list(["" | xs], current_list, result) do
    lines_to_multi_list(xs, [], result ++ [current_list])
  end
  defp lines_to_multi_list([x | xs], current_list, result) do
    new_list = current_list ++ (x |> String.graphemes())
    lines_to_multi_list(xs, new_list, result)
  end

  def file_to_map_list(file) do
    file_to_lines(file) |> lines_to_map_list()
  end

  defp lines_to_map_list(lines) do
    lines_to_map_list(lines, [], [])
  end
  defp lines_to_map_list([], current_map, result) do
    result ++ [current_map]
  end
  defp lines_to_map_list(["" | xs], current_map, result) do
    lines_to_map_list(xs, [], result ++ [current_map])
  end
  defp lines_to_map_list([x | xs], current_map_list, result) do
    new_map = x |> String.graphemes() |> Enum.reduce({0, Map.new()}, fn (item, {index, map}) -> {index + 1, Map.put(map, index, item)} end) |> elem(1)
    lines_to_map_list(xs, current_map_list ++ [new_map], result)
  end

end
