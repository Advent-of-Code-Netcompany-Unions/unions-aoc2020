defmodule App do
  @moduledoc """
  Documentation for `App`.
  """

  def start(_type, _args) do
    children = [
      SupervisorRoot
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
