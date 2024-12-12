defmodule Day12.Day12 do
  def parse_file() do
    lines =
      File.read!("lib/day12/input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    for {line, y} <- Enum.with_index(lines),
        {plant, x} <- Enum.with_index(line),
        into: %{},
        do: {{x, y}, plant}
  end

  def part_1() do
    create_ets_table()
    map = parse_file()

    Enum.reduce(map, 0, fn {pos, _}, sum ->
      {plot_count, sides} = get_region(map, [pos])
      sum + plot_count * length(sides)
    end)
  end

  def part_2() do
    create_ets_table()
    map = parse_file()

    Enum.reduce(map, 0, fn {pos, _}, sum ->
      {plot_count, sides} = get_region(map, [pos])

      side_map = MapSet.new(sides)

      sides =
        side_map
        |> Enum.filter(fn
          {:N, x, y} -> !MapSet.member?(side_map, {:N, x - 1, y})
          {:S, x, y} -> !MapSet.member?(side_map, {:S, x - 1, y})
          {:E, x, y} -> !MapSet.member?(side_map, {:E, x, y - 1})
          {:W, x, y} -> !MapSet.member?(side_map, {:W, x, y - 1})
        end)
        |> Enum.count()

      sum + plot_count * sides
    end)
  end

  defp get_region(_, []), do: {0, []}

  defp get_region(map, [{x, y} = pos | rest]) do
    if visited(pos) do
      get_region(map, rest)
    else
      set_visited(pos)
      plant = Map.get(map, pos)

      {sides, neighbours} =
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
        |> Enum.reduce({[], []}, fn {x2, y2} = pos2, {sides, neighbours} ->
          if Map.get(map, pos2) == plant do
            {sides, [pos2 | neighbours]}
          else
            side =
              cond do
                y2 < y -> {:N, x, y}
                y2 > y -> {:S, x, y}
                x2 > x -> {:E, x, y}
                x2 < x -> {:W, x, y}
              end

            {[side | sides], neighbours}
          end
        end)

      {plot_count, sides2} = get_region(map, rest ++ neighbours)
      {1 + plot_count, sides ++ sides2}
    end
  end

  defp create_ets_table() do
    if :ets.info(:day12_visited) != :undefined do
      :ets.delete(:day12_visited)
    end

    :ets.new(:day12_visited, [:named_table])
  end

  defp visited(pos) do
    case :ets.lookup(:day12_visited, pos) do
      [{_, true}] -> true
      [] -> false
    end
  end

  defp set_visited(pos) do
    :ets.insert(:day12_visited, {pos, true})
  end
end
