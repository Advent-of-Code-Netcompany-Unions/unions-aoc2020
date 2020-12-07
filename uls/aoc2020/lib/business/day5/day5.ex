defmodule Day5 do

  @spec run(String.t()) :: {number, number}
  def run(file) do
    lines = File.read!(file) |> String.split("\n", trim: false)

    res1 = part1(lines)
    res2 = part2(lines)

    {res1, res2}
  end

  def part1(seat_list) do
    part1(seat_list, 0)
  end

  def part1([], highest) do
    highest
  end
  def part1([x | xs], highest) do
    seat_id = to_seat_id(x |> String.graphemes())
    new_highest = max(seat_id, highest)
    part1(xs, new_highest)
  end

  def to_seat_id(lst) do
    {row, rest} = to_seat_row(lst, 0.0, 127.0)
    {column, _} = to_seat_column(rest, 0.0, 7.0)
    round(row * 8 + column)
  end

  def to_seat_row([head | tail], min, _max) when (head == "R" or head == "L") do
    {min, [head | tail]}
  end
  def to_seat_row(["F" | xs], min, max) do
    {new_min, new_max} = lower_half(min, max)
    to_seat_row(xs, new_min, new_max)
  end
  def to_seat_row(["B" | xs], min, max) do
    {new_min, new_max} = upper_half(min, max)
    to_seat_row(xs, new_min, new_max)
  end

  def to_seat_column([], min, _max) do
    {min, []}
  end
  def to_seat_column(["L" | xs], min, max) do
    {new_min, new_max} = lower_half(min, max)
    to_seat_column(xs, new_min, new_max)
  end
  def to_seat_column(["R" | xs], min, max) do
    {new_min, new_max} = upper_half(min, max)
    to_seat_column(xs, new_min, new_max)
  end

  defp lower_half(min, max) do
    num = (max - min) / 2
    new_max = max - num |> Float.floor()
    {min, new_max}
  end
  defp upper_half(min, max) do
    num = (max - min) / 2
    new_min = min + num |> Float.ceil()
    {new_min, max}
  end

  def part2(seat_list) do
    part2(seat_list, [])
  end

  def part2([], lst) do
    max = Enum.reduce(lst, 0, &max/2)
    min = Enum.reduce(lst, max, &min/2)
    range_list = Range.new(min, max) |> Enum.to_list()
    find_missing_memeber(range_list, lst)
  end
  def part2([x | xs], lst) do
    seat_id = to_seat_id(x |> String.graphemes())
    lst = [seat_id | lst]
    part2(xs, lst)
  end

  def find_missing_memeber([x | xs], lst) do
    case Enum.member?(lst, x) do
      true -> find_missing_memeber(xs, lst)
      false -> x
    end
  end

end
