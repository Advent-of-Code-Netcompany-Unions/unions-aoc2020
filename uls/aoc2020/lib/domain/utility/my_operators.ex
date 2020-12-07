defmodule MyOperators do
  def a <~> b, do: not (a and b)

  def a <|> b, do: (a <~> (a <~> b)) <~> (b <~> (a <~> b))
end
