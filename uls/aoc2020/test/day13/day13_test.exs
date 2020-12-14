defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "Day13 example" do
    assert Day13.run("test/Day13/example.txt") == {295, 1068781}
    assert Day13.run("test/Day13/example2.txt", 0) |> elem(1) == 3417
    assert Day13.run("test/Day13/example3.txt", 750_000) |> elem(1) == 754018
    assert Day13.run("test/Day13/example4.txt", 750_000) |> elem(1) == 779210
    assert Day13.run("test/Day13/example5.txt", 1_200_000) |> elem(1) == 1261476
    assert Day13.run("test/Day13/example6.txt", 1_200_000_000) |> elem(1) == 1202161486
  end
end
