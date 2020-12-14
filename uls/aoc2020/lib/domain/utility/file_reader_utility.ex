defmodule FileReaderUtility do

  def file_to_lines(file) do
    File.read!(file) |> String.split("\n", trim: false)
  end

  def file_to_integer_list(file) do
    file_to_lines(file) |> Enum.map(&String.to_integer/1)
  end

  def file_to_multi_list_split_at_empty_line(file) do
    file_to_lines(file) |> lines_to_multi_list_split_at_empty_line()
  end

  def file_to_multi_list_split_at_new_line(file) do
    file_to_lines(file) |> lines_to_multi_list_split_at_new_line()
  end

  defp lines_to_multi_list_split_at_new_line(lines) do
    lines |> Enum.map(&String.graphemes/1)
  end

  defp lines_to_multi_list_split_at_empty_line(lines) do
    lines_to_multi_list_split_at_empty_line(lines, [], [])
  end
  defp lines_to_multi_list_split_at_empty_line([], current_list, result) do
    result ++ [current_list]
  end
  defp lines_to_multi_list_split_at_empty_line(["" | xs], current_list, result) do
    lines_to_multi_list_split_at_empty_line(xs, [], result ++ [current_list])
  end
  defp lines_to_multi_list_split_at_empty_line([x | xs], current_list, result) do
    new_list = current_list ++ (x |> String.graphemes())
    lines_to_multi_list_split_at_empty_line(xs, new_list, result)
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
