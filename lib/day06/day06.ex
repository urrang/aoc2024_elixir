defmodule Day06.Day06 do
  def parse_file() do
    lines =
      File.read!("lib/day06/example.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    map =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(line),
          into: %{},
          do: {{x, y}, char}

    {start_pos, _} = Enum.find(map, fn {_, v} -> v == "^" end)

    {map, start_pos}
  end

  def part_1() do
    {map, start_pos} = parse_file()

    walk(map, start_pos)
    |> MapSet.size()
  end

  def part_2() do
    {map, start_pos} = parse_file()

    walk(map, start_pos)
    |> Task.async_stream(fn visited ->
      altered_map = Map.put(map, visited, "#")
      check_for_loop(altered_map, start_pos)
    end)
    |> Enum.filter(fn {:ok, loop} -> loop end)
    |> Enum.count()
  end

  defp walk(map, pos, direction \\ :up, visited \\ MapSet.new()) do
    visited = MapSet.put(visited, pos)
    next_pos = move(pos, direction)

    case map[next_pos] do
      nil -> visited
      "#" -> walk(map, pos, turn(direction), visited)
      _ -> walk(map, next_pos, direction, visited)
    end
  end

  defp check_for_loop(map, pos, direction \\ :up, visited \\ MapSet.new()) do
    if MapSet.member?(visited, {pos, direction}) do
      true
    else
      visited = MapSet.put(visited, {pos, direction})
      next_pos = move(pos, direction)

      case map[next_pos] do
        nil -> false
        "#" -> check_for_loop(map, pos, turn(direction), visited)
        _ -> check_for_loop(map, next_pos, direction, visited)
      end
    end
  end

  defp move({x, y}, :up), do: {x, y - 1}
  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :down), do: {x, y + 1}
  defp move({x, y}, :left), do: {x - 1, y}

  defp turn(:up), do: :right
  defp turn(:right), do: :down
  defp turn(:down), do: :left
  defp turn(:left), do: :up
end
