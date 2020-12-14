defmodule NumberParseUtility do

  def parse_number_with_sign(string) do
    sign = cond do
      string |> String.match?(~r/\+/) -> 1
      string |> String.match?(~r/\-/) -> -1
      true -> raise "InvalidArgumentException"
    end

    num = ~r/[0-9]+/ |> Regex.scan(string) |> List.last() |> List.last() |> String.to_integer()
    num * sign
  end

end
