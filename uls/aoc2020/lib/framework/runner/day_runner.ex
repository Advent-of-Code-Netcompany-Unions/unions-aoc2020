defmodule Runner.DayRunner do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(initial_state) do
    new_state = run_day_list(initial_state)
    {:ok, new_state}
  end

  @impl true
  def handle_cast(:run, state) do
    new_state = run_day_list(state)
    {:noreply, new_state}
  end

  defp run_day_list([]) do
    []
  end
  defp run_day_list([head | tail]) do
    case head do
      :day1 -> Day1.run("lib/business/day1/input.txt") |> print_day_result("Day1")
      :day2 -> Day2.run("lib/business/day2/input.txt") |> print_day_result("Day2")
      :day3 -> Day3.run("lib/business/day3/input.txt") |> print_day_result("Day3")
      :day4 -> Day4.run("lib/business/day4/input.txt") |> print_day_result("Day4")
      :day5 -> Day5.run("lib/business/day5/input.txt") |> print_day_result("Day5")
      :day6 -> Day6.run("lib/business/day6/input.txt") |> print_day_result("Day6")
      :day7 -> Day7.run("lib/business/day7/input.txt") |> print_day_result("Day7")
      :day8 -> Day8.run("lib/business/day8/input.txt") |> print_day_result("Day8")
      :day9 -> Day9.run("lib/business/day9/input.txt", 25) |> print_day_result("Day9")
      :day10 -> Day10.run("lib/business/day10/input.txt") |> print_day_result("Day10")
      :day11 -> Day11.run("lib/business/day11/input.txt") |> print_day_result("Day11")
      :day12 -> Day12.run("lib/business/day12/input.txt") |> print_day_result("Day12")
      :day13 -> Day13.run("lib/business/day13/input.txt", 100724043002531) |> print_day_result("Day13")
    end

    run_day_list(tail)
  end

  defp print_day_result(tuple, day_string) do
    tuple |> elem(0) |> (fn(str) -> IO.puts("#{day_string} - part1 => #{str}") end).()
    tuple |> elem(1) |> (fn(str) -> IO.puts("#{day_string} - part2 => #{str}") end).()
  end
end
