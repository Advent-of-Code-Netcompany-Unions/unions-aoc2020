defmodule NumberUtility do

  @spec in_interval_inclusive?(number(), number(), number()) :: boolean
  def in_interval_inclusive?(number, min, max) do
    min <= number && number <= max
  end

end
