defmodule ConsoleCPU do
  @acc "acc"

  def parse_instructions_from_file(file) do
    file |> FileReaderUtility.file_to_lines() |> parse_instructions()
  end

  defp parse_instructions(lst) do
    parse_instructions(lst, [])
  end
  defp parse_instructions([], result_list) do
    result_list |> Enum.reverse()
  end
  defp parse_instructions([x | xs], result_list) do
    instruction = cond do
      String.match?(x, ~r/^nop/) -> {:nop, 0}
      String.match?(x, ~r/^acc \+/) -> {:add, x |> String.split("+") |> List.last() |> String.to_integer()}
      String.match?(x, ~r/^acc \-/) -> {:sub, x |> String.split("-") |> List.last() |> String.to_integer()}
      String.match?(x, ~r/^jmp/) -> {:jmp, x |> NumberParseUtility.parse_number_with_sign()}
    end

    parse_instructions(xs, [instruction | result_list])
  end

  def run_instructions(lst) do
    run_instructions(lst, 0, Map.new() |> Map.put(@acc, 0), MapSet.new())
  end
  defp run_instructions(lst, index, state, _executed_indices) when index >= length(lst) do
    {:ok, "Sucess", state}
  end
  defp run_instructions(lst, index, state, executed_indices) do
    case executed_indices |> MapSet.member?(index) do
      true ->
        {:error, "Loop detected", state}
      false ->
        new_executed_indices = executed_indices |> MapSet.put(index)
        {new_index, new_state} = run_instruction(lst |> Enum.at(index), index, state)
        run_instructions(lst, new_index, new_state, new_executed_indices)
    end
  end

  defp run_instruction({:nop, _}, index, state) do
    {index + 1, state}
  end
  defp run_instruction({:add, number}, index, state) do
    acc = state |> Map.get(@acc)
    {index + 1, Map.put(state, @acc, acc + number)}
  end
  defp run_instruction({:sub, number}, index, state) do
    acc = state |> Map.get(@acc)
    {index + 1, Map.put(state, @acc, acc - number)}
  end
  defp run_instruction({:jmp, number}, index, state) do
    {index + number, state}
  end

end
