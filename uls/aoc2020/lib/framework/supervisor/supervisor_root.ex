defmodule SupervisorRoot do
  use Supervisor

  def start_link(state) do
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    sup_flags = %{
      intensity: 0,
      period: 1,
      strategy: :one_for_one
    }

    children = [
      %{
        id: DayRunner,
        start: {Runner.DayRunner, :start_link, [Application.fetch_env!(:aoc2020, :day_list)]},
        restart: :temporary,
        modules: :dynamic,
        shutdown: 50_000,
        type: :worker
      }
    ]

    {:ok, {sup_flags, children}}
  end
end
