defmodule Day13.Day13 do
  def parse_file() do
    File.read!("lib/day13/input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn machine ->
      machine
      |> String.split("\n", trim: true)
      |> Enum.map(&get_xy/1)
    end)
  end

  defp get_xy(str) do
    [[x], [y]] = Regex.scan(~r/\d+/, str)
    {String.to_integer(x), String.to_integer(y)}
  end

  def part_1() do
    parse_file()
    |> Enum.reduce(0, fn machine, sum -> sum + get_cost(machine) end)
  end

  def part_2() do
    parse_file()
    |> Enum.reduce(0, fn [a, b, {px, py}], sum ->
      sum + get_cost([a, b, {px + 10_000_000_000_000, py + 10_000_000_000_000}])
    end)
  end

  defp get_cost([{ax, ay}, {bx, by}, {px, py}]) do
    b = ay * ax + by * ax - (ax * ay + bx * ay)
    p = py * ax - px * ay

    if rem(p, b) != 0 do
      0
    else
      b = div(p, b)
      a = div(px - b * bx, ax)
      a * 3 + b
    end
  end
end
