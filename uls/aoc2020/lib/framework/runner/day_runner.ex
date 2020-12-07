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
    end

    run_day_list(tail)
  end

  defp print_day_result(tuple, day_string) do
    tuple |> elem(0) |> (fn(str) -> IO.puts("#{day_string} - part1 => #{str}") end).()
    tuple |> elem(1) |> (fn(str) -> IO.puts("#{day_string} - part2 => #{str}") end).()
  end
end
