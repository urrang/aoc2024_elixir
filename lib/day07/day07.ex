defmodule Day07.Day07 do
  def parse_file() do
    File.read!("lib/day07/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [value, nums] = String.split(line, ":", trim: true)

      nums =
        String.split(nums, " ", trim: true)
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(value), nums}
    end)
  end

  def part_1() do
    parse_file()
    |> Enum.filter(fn {value, nums} -> is_valid(false, value, nums, 0) end)
    |> Enum.reduce(0, fn {value, _}, acc -> acc + value end)
  end

  def part_2() do
    parse_file()
    |> Task.async_stream(fn {value, nums} ->
      if is_valid(true, value, nums, 0), do: value, else: 0
    end)
    |> Enum.reduce(0, fn {:ok, num}, acc -> acc + num end)
  end

  defp is_valid(_, value, [], acc), do: acc == value

  defp is_valid(part2, value, [num | rest], acc) do
    if acc > value do
      false
    else
      is_valid(part2, value, rest, acc + num) or
        is_valid(part2, value, rest, acc * num) or
        (part2 and is_valid(part2, value, rest, String.to_integer("#{acc}#{num}")))
    end
  end
end
