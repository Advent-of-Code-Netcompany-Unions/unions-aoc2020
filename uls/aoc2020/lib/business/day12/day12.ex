defmodule Day12 do

  @spec run(String.t()) :: {number, number}
  def run(file) do
    navigation_list = file |> Navigator.parse_navigations_from_file()

    res1 = navigation_list |> part1()
    res2 = navigation_list |> part2()

    {res1, res2}
  end

  def part1(navigation_list) do
    {{x, y}, _direction} = navigation_list |> Navigator.move_all_ship({0, 0}, :east)
    abs(x) + abs(y)
  end

  def part2(navigation_list) do
    {{x, y}, _direction} = navigation_list |> Navigator.move_all_waypoint({0, 0}, {10, 1})
    abs(x) + abs(y)
  end

end
