defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "Day5 example" do
    assert Day5.part1(["FBFBBFFRLR"]) == 357
    assert Day5.part1(["BFFFBBFRRR"]) == 567
    assert Day5.part1(["FFFBBBFRRR"]) == 119
    assert Day5.part1(["BBFFBBFRLL"]) == 820

    assert Day5.run("test/day5/example.txt") |> elem(0) == 820
  end
end
