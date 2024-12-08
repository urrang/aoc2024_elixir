defmodule Day08.Day08 do
  def parse_file() do
    lines =
      File.read!("lib/day08/input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    grid =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(line),
          into: %{},
          do: {{x, y}, char}

    grid =
      grid
      |> Enum.filter(fn {_, char} -> char != "." end)
      |> Enum.group_by(fn {_, char} -> char end, fn {coord, _} -> coord end)

    x_max = length(Enum.at(lines, 0))
    y_max = length(lines)
    {grid, x_max, y_max}
  end

  def part_1() do
    {grid, x_max, y_max} = parse_file()

    Map.values(grid)
    |> Enum.flat_map(fn positions -> get_antinodes(positions) end)
    |> then(fn items -> MapSet.new(items) end)
    |> Enum.filter(fn {x, y} ->
      x >= 0 && y >= 0 && x < x_max && y < y_max
    end)
    |> Enum.count()
  end

  def part_2() do
    {grid, x_max, y_max} = parse_file()

    Map.values(grid)
    |> Enum.reduce(MapSet.new(), fn positions, acc ->
      nodes = get_all(positions, x_max, y_max)
      MapSet.union(acc, MapSet.new(nodes))
    end)
    |> Enum.count()
  end

  defp get_antinodes(positions) do
    Enum.reduce(positions, [], fn {ax, ay}, list ->
      nodes =
        Enum.flat_map(positions, fn {bx, by} ->
          x_diff = ax - bx
          y_diff = ay - by

          if x_diff == 0 and y_diff == 0 do
            []
          else
            [{ax + x_diff, ay + y_diff}, {bx - x_diff, by - y_diff}]
          end
        end)

      Enum.concat(list, nodes)
    end)
  end

  defp get_all(positions, x_max, y_max) do
    Enum.reduce(positions, MapSet.new(), fn {ax, ay}, acc ->
      nodes =
        Enum.flat_map(positions, fn {bx, by} ->
          x_step = ax - bx
          y_step = ay - by

          valid = fn {x, y} -> x >= 0 && x < x_max && y >= 0 && y < y_max end

          back =
            Enum.reduce_while(0..50, [], fn step, acc ->
              node = {ax - step * x_step, ay - step * y_step}

              if valid.(node), do: {:cont, [node | acc]}, else: {:halt, acc}
            end)

          forward =
            Enum.reduce_while(0..50, [], fn step, acc ->
              node = {ax + step * x_step, ay + step * y_step}

              if valid.(node), do: {:cont, [node | acc]}, else: {:halt, acc}
            end)

          back ++ forward
        end)

      MapSet.union(acc, MapSet.new(nodes))
    end)
  end
end
