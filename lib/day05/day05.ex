defmodule Day05.Day05 do
  def parse_file() do
    {rules, updates} =
      File.read!("lib/day05/input.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))
      |> List.to_tuple()

    rules =
      rules
      |> Enum.flat_map(fn rule ->
        [a, b] = String.split(rule, "|") |> Enum.map(&String.to_integer/1)
        [{{a, b}, true}, {{b, a}, false}]
      end)
      |> Map.new()

    updates =
      updates
      |> Enum.map(fn line ->
        String.split(line, ",") |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  def part_1() do
    {rules, updates} = parse_file()

    updates
    |> Enum.filter(&is_valid_update(&1, rules))
    |> add_middle_numbers()
  end

  def part_2() do
    {rules, updates} = parse_file()

    updates
    |> Enum.filter(fn update -> !is_valid_update(update, rules) end)
    |> Enum.map(&Enum.sort(&1, fn a, b -> Map.get(rules, {a, b}, true) end))
    |> add_middle_numbers()
  end

  defp is_valid_update([_], _), do: true

  defp is_valid_update([head | tail], rules) do
    Map.get(rules, {head, hd(tail)}, true) and is_valid_update(tail, rules)
  end

  defp add_middle_numbers([]), do: 0

  defp add_middle_numbers([head | tail]) do
    Enum.at(head, div(length(head), 2)) + add_middle_numbers(tail)
  end
end
