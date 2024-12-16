defmodule Day14.Day14 do
  @x_max 100
  @y_max 102

  def parse_file() do
    File.read!("lib/day14/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d+/, line)
      |> Enum.map(fn [x] -> String.to_integer(x) end)
      |> List.to_tuple()
    end)
  end

  def part_1() do
    parse_file()
    |> Enum.map(fn robot -> move(robot, 100) end)
    |> Enum.map(fn {x, y, _, _} -> get_quadrant(x, y) end)
    |> Enum.reject(&(&1 == nil))
    |> Enum.frequencies()
    |> Enum.reduce(1, fn {_, count}, acc -> acc * count end)
  end

  def part_2() do
    robots = parse_file()
    find_tree(robots)
  end

  defp move({px, py, vx, vy}, seconds) do
    x_new = teleport(@x_max, px + rem(vx * seconds, @x_max + 1))
    y_new = teleport(@y_max, py + rem(vy * seconds, @y_max + 1))

    {x_new, y_new, vx, vy}
  end

  defp teleport(max, num) do
    cond do
      num < 0 -> max + num + 1
      num > max -> num - max - 1
      true -> num
    end
  end

  defp get_quadrant(x, y) do
    left = x - div(@x_max, 2)
    top = y - div(@y_max, 2)

    cond do
      left == 0 or top == 0 -> nil
      left < 0 and top < 0 -> {0, 0}
      left < 0 and top > 0 -> {0, 1}
      left > 0 and top < 0 -> {1, 0}
      left > 0 and top > 0 -> {1, 1}
    end
  end

  defp find_tree(robots, seconds \\ 1) do
    positions =
      Enum.map(robots, fn robot ->
        {x, y, _, _} = move(robot, seconds)
        {x, y}
      end)

    unique_positions = MapSet.size(MapSet.new(positions))

    if unique_positions == length(positions) do
      seconds
    else
      find_tree(robots, seconds + 1)
    end
  end
end
