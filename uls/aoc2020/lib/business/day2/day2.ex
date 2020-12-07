defmodule Day2 do
  import MyOperators

  @spec run(String.t()) :: {number, number}
  def run(file) do
    lines = File.read!(file) |> String.split("\n", trim: true)

    res1 = part1(lines, 0)
    res2 = part2(lines, 0)

    {res1, res2}
  end

  @spec part1(list(), number()) :: number()
  def part1([], n) do
    n
  end
  def part1([line | lines], n) do
    spec = extract_spec(line)

    count = spec.password |> String.graphemes() |> Enum.count(& &1 == spec.character)
    to_int = spec.interval_1 <= count and count <= spec.interval_2 && 1 || 0

    part1(lines, n + to_int)
  end

  @spec part2(list(), number()) :: number()
  def part2([], n) do
    n
  end
  def part2([line | lines], n) do
    spec = extract_spec(line)

    b = (String.at(spec.password, spec.interval_1 - 1) == spec.character) <|> (String.at(spec.password, spec.interval_2 - 1) == spec.character)
    to_int = b && 1 || 0

    part2(lines, n + to_int)
  end

  defp extract_spec(line) do
    split = String.split(line, " ", trim: true)
    interval_spec = split |> Enum.at(0)
    matcher_spec = split |> Enum.at(1)
    str_spec = split |> Enum.at(2)

    interval_1 = interval_spec |> String.split("-") |> Enum.at(0) |> Integer.parse() |> elem(0)
    interval_2 = interval_spec |> String.split("-") |> Enum.at(1) |> Integer.parse() |> elem(0)
    character = matcher_spec |> String.replace(":", "")

    %{
      interval: interval_spec,
      interval_1: interval_1,
      interval_2: interval_2,
      character: character,
      password: str_spec
    }
  end
end
