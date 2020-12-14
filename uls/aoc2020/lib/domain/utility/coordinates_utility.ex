defmodule CoordinatesUtility do

  def generate_coordinates({start_x, start_y}, {end_x, end_y}) do
    x_list = Range.new(start_x, end_x) |> Enum.to_list()
    y_list = Range.new(start_y, end_y) |> Enum.to_list()

    List.foldl(
      x_list,
      [],
      fn (item, lst) -> lst ++ Enum.zip(
        List.duplicate(item, y_list |> length()),
        y_list
      )
      end
    )
  end

  def get_element(board, {x, y}) do
    cond do
      x < 0 -> nil
      y < 0 -> nil
      board |> Enum.at(x) == nil -> nil
      true -> board |> Enum.at(x) |> Enum.at(y)
    end
  end

  def update_element(board, {x, y}, value) do
    board |> List.replace_at(x, board |> Enum.at(x) |> List.replace_at(y, value))
  end

end
