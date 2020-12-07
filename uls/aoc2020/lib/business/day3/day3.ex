defmodule Day3 do
  @tree "#"

  @spec run(String.t()) :: {number, number}
  def run(file) do
    lines = File.read!(file) |> String.split("\n", trim: true)
    board = create_board(lines)

    res1 = part1(board)
    res2 = part2(board)

    {res1, res2}
  end

  def create_board(list) do
    create_board(list, Map.new(), 0)
  end

  def create_board([], board, _) do
    board
  end
  def create_board([x | ys], board, index) do
    row = String.graphemes(x) |> create_board_row(Map.new(), 0)
    create_board(ys, Map.put(board, index, row), index + 1)
  end

  def create_board_row([], row, _) do
    row
  end
  def create_board_row([x | xs], row, index) do
    create_board_row(xs, Map.put(row, index, x), index + 1)
  end

  def part1(board) do
    part1(board, 1, 3)
  end
  def part1(board, delta_row, delta_column) do
    height = map_size(board)
    width = map_size(board[0])

    part1(board, height, width, delta_row, delta_column, 0, 0, 0)
  end
  def part1(_board, height, _width, _delta_row, _delta_column, row, _column, n) when row > height do
    n
  end
  def part1(board, height, width, delta_row, delta_column, row, column, n) do
    new_row = row + delta_row
    new_column = rem(column + delta_column, width)
    tree = board[new_row][new_column] == @tree && 1 || 0
    part1(board, height, width, delta_row, delta_column, new_row, new_column, n + tree)
  end

  def part2(board) do
    part1(board, 1, 1) * part1(board, 1, 3) * part1(board, 1, 5) * part1(board, 1, 7) * part1(board, 2, 1)
  end
end
