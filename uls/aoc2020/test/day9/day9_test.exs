defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "Day9 example" do
    assert Day9.run("test/Day9/example.txt", 5) == {127, 62}
  end
end
