defmodule NumberUtility do

  @spec in_interval_inclusive?(number(), number(), number()) :: boolean
  def in_interval_inclusive?(number, min, max) do
    min <= number && number <= max
  end

  @spec numbers_hit_target_2(list(), integer()) :: boolean
  def numbers_hit_target_2(lst, target) do
    numbers_hit_target_2(lst, lst, target)
  end
  @spec numbers_hit_target_2(list(), list(), integer()) :: boolean
  defp numbers_hit_target_2([], [], _target) do
    false
  end
  defp numbers_hit_target_2([], [_ | ys], target) do
    numbers_hit_target_2(ys, ys, target)
  end
  defp numbers_hit_target_2([x | xs], [y | ys], target) do
    case x + y == target do
       true -> true
       false -> numbers_hit_target_2(xs, [y | ys], target)
    end
  end

end
