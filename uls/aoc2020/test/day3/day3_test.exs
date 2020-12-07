defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Day3 example" do
    assert Day3.run("test/day3/example.txt") == {7, 336}
  end
end
