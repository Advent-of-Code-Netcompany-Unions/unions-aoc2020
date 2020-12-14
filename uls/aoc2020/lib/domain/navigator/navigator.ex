defmodule Navigator do

  def parse_navigations_from_file(file) do
    file |> FileReaderUtility.file_to_lines() |> parse_navigations()
  end

  defp parse_navigations(lst) do
    lst |> Enum.map(
      fn (item) ->
        case String.split_at(item, 1) do
          {"N", num} -> {:north, num |> String.to_integer()}
          {"S", num} -> {:south, num |> String.to_integer()}
          {"E", num} -> {:east, num |> String.to_integer()}
          {"W", num} -> {:west, num |> String.to_integer()}
          {"L", num} -> {:left, num |> String.to_integer()}
          {"R", num} -> {:right, num |> String.to_integer()}
          {"F", num} -> {:forward, num |> String.to_integer()}
        end
      end
    )
  end

  def move_all_ship(lst, {start_x, start_y}, start_direction) do
    List.foldl(lst, {{start_x, start_y}, start_direction},
      fn item, {current_position, current_direction} ->
        move_ship(item, current_position, current_direction)
      end
    )
  end

  def move_all_waypoint(lst, {start_x, start_y}, waypoint_position) do
    List.foldl(lst, {{start_x, start_y}, waypoint_position},
      fn item, {current_position, current_waypoint_position} ->
        move_waypoint(item, current_position, current_waypoint_position)
      end
    )
  end

  defp move_ship(navigation, {x, y}, direction) do
    new_pos = case navigation do
      {:north, num} -> {x, y + num}
      {:south, num} -> {x, y - num}
      {:east, num} -> {x + num, y}
      {:west, num} -> {x - num, y}
      {:forward, num} -> move_ship({direction, num}, {x, y}, direction) |> elem(0)
      _ -> {x, y}
    end

    new_direction = case navigation do
      {:left, _} -> calculate_direction_ship(navigation, direction)
      {:right, _} -> calculate_direction_ship(navigation, direction)
      _ -> direction
    end

    {new_pos, new_direction}
  end

  defp calculate_direction_ship(navigation, direction) do
    clockwise_rotation = case navigation do
      {:left, 90} -> 270
      {:left, 270} -> 90
      {:right, 90} -> 90
      {:right, 270} -> 270
      {_, 0} -> 0
      {_, 180} -> 180
      {_, 360} -> 360
    end

    case {direction, clockwise_rotation} do
      {:north, 90} -> :east
      {:north, 180} -> :south
      {:north, 270} -> :west
      {:east, 90} -> :south
      {:east, 180} -> :west
      {:east, 270} -> :north
      {:south, 90} -> :west
      {:south, 180} -> :north
      {:south, 270} -> :east
      {:west, 90} -> :north
      {:west, 180} -> :east
      {:west, 270} -> :south
    end
  end

  defp move_waypoint(navigation, {ship_x, ship_y}, {way_x, way_y}) do
    ship_pos = {ship_x, ship_y}
    waypoint_pos = {way_x, way_y}

    case navigation do
      {:north, num} -> {ship_pos, {way_x, way_y + num}}
      {:south, num} -> {ship_pos, {way_x, way_y - num}}
      {:east, num} -> {ship_pos, {way_x + num, way_y}}
      {:west, num} -> {ship_pos, {way_x - num, way_y}}
      {:forward, num} -> {{ship_x + (way_x * num), ship_y + (way_y * num)}, waypoint_pos}
      {:left, _} -> {ship_pos, calculate_waypoint_position(navigation, {way_x, way_y})}
      {:right, _} -> {ship_pos, calculate_waypoint_position(navigation, {way_x, way_y})}
    end
  end

  defp calculate_waypoint_position(navigation, {way_x, way_y}) do
    rotation = case navigation do
      {:left, num} -> num
      {:right, num} -> -num
    end

    radians = rotation |> Math.deg2rad()
    new_x = round(way_x * Math.cos(radians) - way_y * Math.sin(radians))
    new_y = round(way_x * Math.sin(radians) + way_y * Math.cos(radians))

    {new_x, new_y}
  end

end
