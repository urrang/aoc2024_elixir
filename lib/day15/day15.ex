defmodule Day15.Day15 do
  def parse_file(p2 \\ false) do
    [map_lines, moves_lines] =
      File.read!("lib/day15/input.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    map_lines =
      Enum.map(map_lines, fn line ->
        if p2 do
          Enum.reduce(String.graphemes(line), [], fn char, list ->
            case char do
              "#" -> list ++ ["#", "#"]
              "O" -> list ++ ["[", "]"]
              "." -> list ++ [".", "."]
              "@" -> list ++ ["@", "."]
            end
          end)
        else
          String.graphemes(line)
        end
      end)

    map =
      for {line, y} <- Enum.with_index(map_lines),
          {tile, x} <- Enum.with_index(line),
          into: %{},
          do: {{x, y}, tile}

    moves = Enum.flat_map(moves_lines, &String.graphemes/1)

    {map, moves}
  end

  def part_1() do
    {map, moves} = parse_file()

    {robot_position, _} = Enum.find(map, fn {_, tile} -> tile == "@" end)

    moves
    |> Enum.reduce({map, robot_position}, fn direction, {map, pos} ->
      move(map, pos, direction)
    end)
    |> elem(0)
    |> Enum.filter(fn {_, unit} -> unit == "O" end)
    |> Enum.reduce(0, fn {{x, y}, _}, acc ->
      acc + x + y * 100
    end)
  end

  def part_2() do
    {map, moves} = parse_file(true)

    {robot_position, _} = Enum.find(map, fn {_, tile} -> tile == "@" end)

    moves
    |> Enum.reduce({map, robot_position}, fn direction, {map, pos} ->
      move(map, pos, direction)
    end)
    |> elem(0)
    |> Enum.filter(fn {_, unit} -> unit == "[" end)
    |> Enum.reduce(0, fn {{x, y}, _}, acc ->
      acc + x + y * 100
    end)
  end

  defp move(map, pos, direction) do
    pos2 = next_pos(pos, direction)

    case Map.get(map, pos2) do
      "." ->
        map = swap(map, pos, pos2)
        {map, pos2}

      "#" ->
        {map, pos}

      "O" ->
        case find_spot_for_box(map, pos2, direction) do
          nil ->
            {map, pos}

          pos3 ->
            map = swap(map, pos3, pos2)
            map = swap(map, pos, pos2)
            {map, pos2}
        end

      "[" ->
        new_map =
          if is_horizontal(direction) do
            move_horiz(map, pos2, direction)
          else
            {x, y} = pos2
            move_vert(map, pos2, {x + 1, y}, direction)
          end

        if new_map == nil do
          {map, pos}
        else
          {swap(new_map, pos, pos2), pos2}
        end

      "]" ->
        new_map =
          if is_horizontal(direction) do
            move_horiz(map, pos2, direction)
          else
            {x, y} = pos2
            move_vert(map, {x - 1, y}, pos2, direction)
          end

        if new_map == nil do
          {map, pos}
        else
          map = swap(new_map, pos, pos2)
          {map, pos2}
        end
    end
  end

  defp is_horizontal(direction), do: direction == "<" or direction == ">"

  defp move_horiz(map, pos, direction) do
    pos2 = next_pos(pos, direction)

    case Map.get(map, pos2) do
      "#" ->
        nil

      "." ->
        swap(map, pos, pos2)

      _ ->
        case move_horiz(map, pos2, direction) do
          nil -> nil
          map -> swap(map, pos, pos2)
        end
    end
  end

  defp move_vert(map, pos1, pos2, direction) do
    pos1_next = next_pos(pos1, direction)
    pos2_next = next_pos(pos2, direction)

    case {Map.get(map, pos1_next), Map.get(map, pos2_next)} do
      {"#", _} ->
        nil

      {_, "#"} ->
        nil

      {".", "."} ->
        map = swap(map, pos1, pos1_next)
        swap(map, pos2, pos2_next)

      {"[", "]"} ->
        case move_vert(map, pos1_next, pos2_next, direction) do
          nil -> nil
          map -> swap(swap(map, pos1, pos1_next), pos2, pos2_next)
        end

      {"]", "["} ->
        {x, y} = pos1_next
        map = move_vert(map, {x - 1, y}, {x, y}, direction)

        if map == nil do
          nil
        else
          {x, y} = pos2_next
          map = move_vert(map, {x, y}, {x + 1, y}, direction)

          if map == nil do
            nil
          else
            map = swap(map, pos1, pos1_next)
            swap(map, pos2, pos2_next)
          end
        end

      {".", "["} ->
        {x, y} = pos2_next

        case move_vert(map, {x, y}, {x + 1, y}, direction) do
          nil -> nil
          map -> swap(swap(map, pos1, pos1_next), pos2, pos2_next)
        end

      {"]", "."} ->
        {x, y} = pos1_next

        case move_vert(map, {x - 1, y}, {x, y}, direction) do
          nil -> nil
          map -> swap(swap(map, pos1, pos1_next), pos2, pos2_next)
        end
    end
  end

  defp swap(map, pos1, pos2) do
    value1 = Map.get(map, pos1)
    value2 = Map.get(map, pos2)
    map = Map.put(map, pos1, value2)
    Map.put(map, pos2, value1)
  end

  defp find_spot_for_box(map, {x, y}, direction) do
    {nx, ny} = next_pos({x, y}, direction)

    case Map.get(map, {nx, ny}) do
      "#" -> nil
      "." -> {nx, ny}
      "O" -> find_spot_for_box(map, {nx, ny}, direction)
    end
  end

  defp next_pos({x, y}, "<"), do: {x - 1, y}
  defp next_pos({x, y}, ">"), do: {x + 1, y}
  defp next_pos({x, y}, "^"), do: {x, y - 1}
  defp next_pos({x, y}, "v"), do: {x, y + 1}
end
