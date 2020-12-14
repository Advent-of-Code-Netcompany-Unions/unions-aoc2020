defmodule Day13 do
  @ignore "x"

  @spec run(String.t()) :: {number, number}
  def run(file) do
    run(file, 0)
  end

  @spec run(String.t(), pos_integer()) :: {number, number}
  def run(file, offset) do
    file_list = file |> FileReaderUtility.file_to_lines()

    start_timestamp = file_list |> hd |> String.to_integer()

    res1 = file_list |> tl |> hd |> parse_bus_list_part1() |> part1(start_timestamp)
    res2 = file_list |> tl |> hd |> parse_bus_list_part2() |> part2(offset)

    {res1, res2}
  end

  defp parse_bus_list_part1(full_list) do
    full_list |> String.split(",", trim: true)
              |> Enum.filter(fn item -> item != @ignore end)
              |> Enum.map(fn item -> item |> String.to_integer() end)
  end

  defp parse_bus_list_part2(full_list) do
    full_list |> String.split(",", trim: true)
              |> Enum.map(fn item -> case item do
                            "x" -> "1"
                            x -> x
                            end
                          end)
              |> Enum.map(fn item -> item |> String.to_integer() end)
  end

  def part1(bus_list, start_timestamp) do
    {timestamp, bus_id} = part1_find(bus_list, start_timestamp)
    (timestamp - start_timestamp) * bus_id
  end

  defp part1_find(bus_list, current_timestamp) do
    case bus_list |> Enum.find(nil, &(bus_departs_at_time?(&1, current_timestamp))) do
      nil -> part1_find(bus_list, current_timestamp + 1)
      found -> {current_timestamp, found}
    end
  end

  def bus_departs_at_time?(bus_id, time) do
    case bus_id do
      1 -> true
      _ -> rem(time, bus_id) == 0
    end
  end

  def part2(bus_list, offset) do
    bus_id = bus_list |> hd
    {first_timeslot, _} = part1_find([bus_id], offset)
    part2(bus_list, first_timeslot, bus_id)
  end

  def part2(bus_list, current_time, delta_time) do
    # IO.inspect(current_time)

    {found, _, acc} = Enum.reduce_while(
      bus_list,
      {true, 0, 1},
      fn element, {_truth, i, acc} ->
        case bus_departs_at_time?(element, current_time + i) do
          true -> {:cont, {true, i + 1, acc * element}}
          false -> {:halt, {false, i, acc}}
        end
      end
    )

    case found do
      true -> current_time
      false -> part2(bus_list, current_time + acc, delta_time)
    end
  end

end
