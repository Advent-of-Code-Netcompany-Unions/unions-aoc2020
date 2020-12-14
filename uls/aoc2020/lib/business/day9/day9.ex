defmodule Day9 do

  @spec run(String.t(), pos_integer()) :: {number, number}
  def run(file, preamble) do
    lines = file |> FileReaderUtility.file_to_lines() |> Enum.map(&String.to_integer/1)

    res1 = lines |> part1(preamble)
    res2 = lines |> part2(res1)

    {res1, res2}
  end

  def part1(lines, preamble) do
    Enum.reduce_while(
      lines |> Enum.with_index() |> Enum.drop(preamble),
      0,
      fn ({x, i}, acc) ->
        case NumberUtility.numbers_hit_target_2(lines |> Enum.slice(i - preamble, preamble), x) do
          true -> {:cont, acc}
          false -> {:halt, x}
        end
      end
    )
  end

  def part2(lines, target) do
    match_list = find_list_sum_to_target(lines, target)
    Enum.min(match_list) + Enum.max(match_list)
  end

  defp find_list_sum_to_target([x | xs], target) do
    case is_list_sum_to_target([x | xs], [], target) do
      {:true, match_list} -> match_list
      _ -> find_list_sum_to_target(xs, target)
    end
  end

  defp is_list_sum_to_target([x | xs], result, target) do
    match_list = [x | result]
    cond do
      Enum.sum(match_list) > target -> {:false, []}
      Enum.sum(match_list) == target -> {:true, match_list}
      true -> is_list_sum_to_target(xs, match_list, target)
    end
  end

end
