defmodule Day8 do
  @acc "acc"

  @spec run(String.t()) :: {number, number}
  def run(file) do
    cpu_instructions = file |> ConsoleCPU.parse_instructions_from_file()

    res1 = cpu_instructions |> part1()
    res2 = cpu_instructions |> part2()

    {res1, res2}
  end

  def part1(cpu_instructions) do
    {_, _, state} = cpu_instructions |> ConsoleCPU.run_instructions()
    state |> Map.get(@acc)
  end

  def part2(cpu_instructions) do
    part2(cpu_instructions, 0)
  end
  def part2(cpu_instructions, index) when index < length(cpu_instructions) do
    new_list = case cpu_instructions |> Enum.at(index) do
      {:nop, number} -> cpu_instructions |> List.replace_at(index, {:jmp, number})
      {:jmp, number} -> cpu_instructions |> List.replace_at(index, {:nop, number})
      _ -> nil
    end

    if (new_list != nil) do
      case new_list |> ConsoleCPU.run_instructions() do
        {:error, _, _} -> part2(cpu_instructions, index + 1)
        {:ok, _, state} -> state |> Map.get(@acc)
      end
    else
      part2(cpu_instructions, index + 1)
    end

  end

end
