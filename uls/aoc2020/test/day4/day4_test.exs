defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "Day4 example" do
    assert Day4.run("test/day4/example.txt") |> elem(0) == 2
    assert Day4.run("test/day4/example2.txt") |> elem(1) == 4
  end
end
