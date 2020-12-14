defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "Day10 example" do
    assert Day10.run("test/Day10/example.txt") == {220, 19208}
    assert Day10.run("test/Day10/example_small.txt") |> elem(1) == 8
  end
end
