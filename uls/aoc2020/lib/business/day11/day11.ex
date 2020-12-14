defmodule Day11 do
  @seat_empty "L"
  @seat_taken "#"
  @floor "."

  @spec run(String.t()) :: {number, number}
  def run(file) do
    run(file, nil)
  end

  def run(file, max_iterations) do
    multi_list = file |> FileReaderUtility.file_to_multi_list_split_at_new_line()

    res1 = multi_list |> part1(max_iterations)
    res2 = multi_list |> part2(max_iterations)

    {res1, res2}
  end

  def part1(multi_list, max_iterations) do
    coordinates = CoordinatesUtility.generate_coordinates({0, 0}, {(multi_list |> length()) - 1, (multi_list |> Enum.at(0) |> length()) - 1})
    part1(coordinates, multi_list, 1, max_iterations)
  end

  defp part1(coordinates, current_state, current_iterations, max_iterations) do
    new_state = part1_run(coordinates, current_state, current_state)

    case current_state == new_state or (max_iterations != nil and current_iterations >= max_iterations) do
      false -> part1(coordinates, new_state, current_iterations + 1, max_iterations)
      true -> new_state |> List.flatten() |> Enum.count(fn item -> item == @seat_taken end)
    end
  end

  def part1_run([], _current_state, new_state) do
    new_state
  end
  def part1_run([coordinate | rest], current_state, new_state) do
    new_value = case CoordinatesUtility.get_element(current_state, coordinate) do
      @seat_empty -> part1_check_seat_empty_rule(coordinate, current_state)
      @seat_taken -> part1_check_seat_taken_rule(coordinate, current_state)
      @floor -> @floor
    end

    part1_run(rest, current_state, CoordinatesUtility.update_element(new_state, coordinate, new_value))
  end

  def part1_check_seat_empty_rule({x, y}, current_state) do
    case part1_neighbour_seats_taken({x, y}, current_state) do
      0 -> @seat_taken
      _ -> @seat_empty
    end
  end

  def part1_check_seat_taken_rule({x, y}, current_state) do
    if part1_neighbour_seats_taken({x, y}, current_state) >= 4, do: @seat_empty, else: @seat_taken
  end

  def part1_neighbour_seats_taken({x, y}, current_state) do
    CoordinatesUtility.generate_coordinates({x - 1, y - 1}, {x + 1, y + 1}) |> List.delete({x, y})
    |> Enum.count(
      fn item ->
        seat = CoordinatesUtility.get_element(current_state, item)
        seat != nil and seat == @seat_taken
      end
    )
  end


  def part2(multi_list, max_iterations) do
    height = multi_list |> length()
    width = multi_list |> Enum.at(0) |> length()
    coordinates = CoordinatesUtility.generate_coordinates({0, 0}, {height - 1, width - 1})
    part2(coordinates, height, width, multi_list, 1, max_iterations)
  end

  defp part2(coordinates, height, width, current_state, current_iterations, max_iterations) do
    new_state = part2_run(coordinates, height, width, current_state, current_state)

    case current_state == new_state or (max_iterations != nil and current_iterations >= max_iterations) do
      false -> part2(coordinates, height, width, new_state, current_iterations + 1, max_iterations)
      true -> new_state |> List.flatten() |> Enum.count(fn item -> item == @seat_taken end)
    end
  end

  def part2_run([], _height, _width, _current_state, new_state) do
    new_state
  end
  def part2_run([coordinate | rest], height, width, current_state, new_state) do
    new_value = case CoordinatesUtility.get_element(current_state, coordinate) do
      @seat_empty -> part2_check_seat_empty_rule(coordinate, height, width, current_state)
      @seat_taken -> part2_check_seat_taken_rule(coordinate, height, width, current_state)
      @floor -> @floor
    end

    part2_run(rest, height, width, current_state, CoordinatesUtility.update_element(new_state, coordinate, new_value))
  end

  def part2_check_seat_empty_rule({x, y}, height, width, current_state) do
    case part2_neighbour_seats_taken({x, y}, height, width, current_state) do
      0 -> @seat_taken
      _ -> @seat_empty
    end
  end

  def part2_check_seat_taken_rule({x, y}, height, width, current_state) do
    if part2_neighbour_seats_taken({x, y}, height, width, current_state) >= 5, do: @seat_empty, else: @seat_taken
  end

  def part2_neighbour_seats_taken({x, y}, height, width, current_state) do
    CoordinatesUtility.generate_coordinates({x - 1, y - 1}, {x + 1, y + 1}) |> List.delete({x, y})
    |> Enum.count(
      fn {item_x, item_y} ->
        part2_check_seat_taken({item_x, item_y}, {item_x - x, item_y - y}, height, width, current_state)
      end
    )
  end

  def part2_check_seat_taken({x, y}, {delta_x, delta_y}, height, width, current_state) do
    cond do
      x < 0 or x >= height -> false
      y < 0 or y >= width -> false
      CoordinatesUtility.get_element(current_state, {x, y}) == @floor ->
        part2_check_seat_taken({x + delta_x, y + delta_y}, {delta_x, delta_y}, height, width, current_state)
      CoordinatesUtility.get_element(current_state, {x, y}) == @seat_empty -> false
      CoordinatesUtility.get_element(current_state, {x, y}) == @seat_taken -> true
    end
  end

end
