defmodule Day10.Day10 do
  def parse_file() do
    lines =
      File.read!("lib/day10/input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    map =
      for {line, y} <- Enum.with_index(lines),
          {height, x} <- Enum.with_index(line),
          into: %{},
          do: {{x, y}, String.to_integer(height)}

    trailheads = Enum.filter(map, fn {_, h} -> h == 0 end)

    {map, trailheads}
  end

  def part_1() do
    {map, trailheads} = parse_file()

    trailheads
    |> Enum.map(&walk(map, [&1]))
    |> Enum.map(&count_unique/1)
    |> Enum.sum()
  end

  def part_2() do
    {map, trailheads} = parse_file()
    Enum.count(walk(map, trailheads))
  end

  defp count_unique(list), do: MapSet.size(MapSet.new(list))

  defp walk(_, []), do: []
  defp walk(map, [{pos, 9} | rest]), do: [pos | walk(map, rest)]
  defp walk(map, [{{x, y}, height} | rest]), do: walk(map, next_steps(map, x, y, height) ++ rest)

  defp next_steps(map, x, y, height) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(fn pos -> {pos, Map.get(map, pos)} end)
    |> Enum.filter(fn {_, new_height} -> new_height != nil && new_height - height == 1 end)
  end
end
