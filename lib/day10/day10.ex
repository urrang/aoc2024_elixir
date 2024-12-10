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
    |> Enum.map(&count_peaks(map, MapSet.new(), [&1]))
    |> Enum.sum()
  end

  def part_2() do
    {map, trailheads} = parse_file()

    trailheads
    |> Enum.map(&count_paths(map, [&1]))
    |> Enum.sum()
  end

  defp count_peaks(_, _, []), do: 0

  defp count_peaks(map, visited, [{pos, 9} | rest]),
    do: 1 + count_peaks(map, MapSet.put(visited, pos), rest)

  defp count_peaks(map, visited, [{{x, y}, height} | rest]) do
    visited = MapSet.put(visited, {x, y})

    next_steps =
      get_next_steps(map, x, y, height)
      |> Enum.reject(fn {pos, _} -> MapSet.member?(visited, pos) end)

    count_peaks(map, visited, next_steps ++ rest)
  end

  defp count_paths(_, []), do: 0

  defp count_paths(map, [{_, 9} | rest]), do: 1 + count_paths(map, rest)

  defp count_paths(map, [{{x, y}, height} | rest]) do
    count_paths(map, get_next_steps(map, x, y, height) ++ rest)
  end

  defp get_next_steps(map, x, y, height) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(fn pos -> {pos, Map.get(map, pos)} end)
    |> Enum.filter(fn {_, new_height} -> new_height != nil && new_height - height == 1 end)
  end
end
