defmodule Day4 do
  import NumberUtility

  @spec run(String.t()) :: {number, number}
  def run(file) do
    lines = File.read!(file) |> String.split("\n", trim: false)
    passport_map_list = create_passport_map_list(lines, Map.new(), [])

    res1 = part1(passport_map_list)
    res2 = part2(passport_map_list)

    {res1, res2}
  end

  @spec create_passport_map_list(list(), map(), [map()]) :: [map()]
  def create_passport_map_list([], current_map, passport_map_list) do
    [current_map | passport_map_list]
  end
  def create_passport_map_list(["" | xs], current_map, passport_map_list) do
    create_passport_map_list(xs, Map.new(), [current_map | passport_map_list])
  end
  def create_passport_map_list([x | xs], current_map, passport_map_list) do
    new_map = create_passport_map(String.split(x, " "), current_map)
    create_passport_map_list(xs, new_map, passport_map_list)
  end

  @spec create_passport_map(list(), map()) :: map()
  defp create_passport_map([], current_map)  do
    current_map
  end
  defp create_passport_map([x | xs], current_map) do
    element = x |> String.split(":")
    key = element |> Enum.at(0)
    value = element |> Enum.at(1)
    current_map = current_map |> Map.put(key, value)
    create_passport_map(xs, current_map)
  end

  defp validator([], _fun, n) do
    n
  end
  defp validator([x | xs], fun, n) do
    valid = fun.(x)
    validator(xs, fun, n + (valid && 1 || 0))
  end

  @spec part1([map()]) :: non_neg_integer()
  def part1(passport_map_list) do
    validator(passport_map_list, &part1_validator/1, 0)
  end

  @spec part1_validator(map) :: boolean
  def part1_validator(map) do
    Map.has_key?(map, "byr")
      && Map.has_key?(map, "iyr")
      && Map.has_key?(map, "eyr")
      && Map.has_key?(map, "hgt")
      && Map.has_key?(map, "hcl")
      && Map.has_key?(map, "ecl")
      && Map.has_key?(map, "pid")
  end

  @spec part2([map()]) :: non_neg_integer()
  def part2(passport_map_list) do
    validator(passport_map_list, &part2_validator/1, 0)
  end

  @spec part2_validator(map) :: boolean
  def part2_validator(map) do
    byr = Map.has_key?(map, "byr") && map["byr"] |> String.to_integer() |> in_interval_inclusive?(1920, 2002)
    iyr = Map.has_key?(map, "iyr") && map["iyr"] |> String.to_integer() |> in_interval_inclusive?(2010, 2020)
    eyr = Map.has_key?(map, "eyr") && map["eyr"] |> String.to_integer() |> in_interval_inclusive?(2020, 2030)
    hgt = Map.has_key?(map, "hgt") && cond do
      String.match?(map["hgt"], ~r/cm/) -> map["hgt"] |> String.replace("cm", "") |> String.to_integer() |> in_interval_inclusive?(150, 193)
      String.match?(map["hgt"], ~r/in/) -> map["hgt"] |> String.replace("in", "") |> String.to_integer() |> in_interval_inclusive?(59, 76)
      true -> false
    end
    hcl = Map.has_key?(map, "hcl") && String.match?(map["hcl"], ~r/^#([0-9]|[a-f]){6}$/)
    ecl = Map.has_key?(map, "ecl") && String.match?(map["ecl"], ~r/^(amb|blu|brn|gry|grn|hzl|oth)$/)
    pid = Map.has_key?(map, "pid") && String.match?(map["pid"], ~r/^(\d){9}$/)

    byr && iyr && eyr && hgt && hcl && ecl && pid
  end
end
