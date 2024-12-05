defmodule Day05.Day05 do
  def parse_file() do
    [rules, updates] =
      File.read!("lib/day05/example.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules =
      for rule <- rules, into: MapSet.new() do
        [a, b] = String.split(rule, "|")
        {String.to_integer(a), String.to_integer(b)}
      end

    updates =
      for update <- updates do
        String.split(update, ",") |> Enum.map(&String.to_integer/1)
      end

    {rules, updates}
  end

  def part_1() do
    {rules, updates} = parse_file()

    updates
    |> Enum.filter(&is_sorted(&1, rules))
    |> sum_middle_numbers()
  end

  def part_2() do
    {rules, updates} = parse_file()

    updates
    |> Enum.reject(&is_sorted(&1, rules))
    |> Enum.map(&Enum.sort(&1, fn a, b -> MapSet.member?(rules, {a, b}) end))
    |> sum_middle_numbers()
  end

  defp is_sorted([_], _), do: true

  defp is_sorted([head | tail], rules) do
    MapSet.member?(rules, {head, hd(tail)}) and is_sorted(tail, rules)
  end

  defp sum_middle_numbers([]), do: 0

  defp sum_middle_numbers([head | tail]) do
    Enum.at(head, div(length(head), 2)) + sum_middle_numbers(tail)
  end
end
