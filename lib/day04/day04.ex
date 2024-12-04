defmodule Day04.Day04 do
  def parse_file() do
    File.read!("lib/day04/example.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Enum.into(%{})
  end

  def part_1() do
    char_map = parse_file()

    char_map
    |> Enum.reduce(0, fn
      {{x, y}, ?X}, acc -> acc + count_xmas(char_map, {x, y})
      _, acc -> acc
    end)
  end

  def part_2() do
    char_map = parse_file()

    char_map
    |> Enum.filter(fn
      {{x, y}, ?A} -> valid_xmas?(char_map, {x, y})
      _ -> false
    end)
    |> Enum.count()
  end

  defp count_xmas(char_map, {x, y}) do
    directions = [
      [{x, y + 1}, {x, y + 2}, {x, y + 3}],
      [{x, y - 1}, {x, y - 2}, {x, y - 3}],
      [{x - 1, y}, {x - 2, y}, {x - 3, y}],
      [{x + 1, y}, {x + 2, y}, {x + 3, y}],
      [{x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}],
      [{x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3}],
      [{x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}],
      [{x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}]
    ]

    directions
    |> Enum.map(&coordinates_to_charlist(&1, char_map))
    |> Enum.filter(fn chars -> chars == ~c"MAS" end)
    |> Enum.count()
  end

  defp valid_xmas?(char_map, {x, y}) do
    d1 = coordinates_to_charlist([{x - 1, y - 1}, {x + 1, y + 1}], char_map)
    d2 = coordinates_to_charlist([{x - 1, y + 1}, {x + 1, y - 1}], char_map)
    d1 in [~c"SM", ~c"MS"] and d2 in [~c"SM", ~c"MS"]
  end

  defp coordinates_to_charlist(coordinates, char_map) do
    Enum.map(coordinates, &Map.get(char_map, &1))
  end
end
