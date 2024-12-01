defmodule Day01.Day01 do
  def parse_file() do
    File.read!("lib/day01/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  def part_1() do
    {left, right} = parse_file()

    Enum.zip([Enum.sort(left), Enum.sort(right)])
    |> Enum.reduce(0, fn {l, r}, acc -> acc + abs(l - r) end)
  end

  def part_2() do
    {left, right} = parse_file()

    right_frequencies = Enum.frequencies(right)

    Enum.frequencies(left)
    |> Enum.reduce(0, fn {num, count}, acc ->
      acc + num * count * Map.get(right_frequencies, num, 0)
    end)
  end
end
