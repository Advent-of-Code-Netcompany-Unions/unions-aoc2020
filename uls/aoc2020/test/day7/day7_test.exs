defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Day7 example" do
    assert Day7.run("test/Day7/example.txt") == {4, 32}
    assert Day7.run("test/Day7/example2.txt") |> elem(1) == 126
  end
end
