defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Day1 example" do
    assert Day1.run("test/day1/example.txt") == {514579, 241861950}
  end
end
