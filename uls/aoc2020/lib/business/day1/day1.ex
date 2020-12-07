defmodule Day1 do
  @target 2020

  @spec run(String.t()) :: {number, number}
  def run(file) do
    content = File.read!(file) |> String.split("\n", trim: true)
    content = Enum.map(content, fn (str) -> {num, _} = Integer.parse(str, 10); num end)

    res1 = part1(content, content)
    res2 = part2(content, content, content)

    {res1, res2}
  end

  @spec part1(list(), list()) :: number
  def part1([], [_ | ys]) do
    part1(ys, ys)
  end
  def part1([x | xs], [y | ys]) do
    case x + y == @target do
       true -> x * y
       _ -> part1(xs, [y | ys])
    end
  end

  @spec part2(list(), list(), list()) :: number
  def part2([], [_ | ys], [z | zs]) do
    part2(ys, ys, [z | zs])
  end
  def part2([], [], [_ | zs]) do
    part2(zs, zs, zs)
  end
  def part2([x | xs], [y | ys], [z | zs]) do
    case x + y + z == @target do
       true -> x * y * z
       _ -> part2(xs, [y | ys], [z | zs])
    end
  end
end
