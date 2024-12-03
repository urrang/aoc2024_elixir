defmodule Day03.Day03 do
  def part_1() do
    solve(~r/mul\((\d+),(\d+)\)/)
  end

  def part_2() do
    solve(~r/mul\((\d+),(\d+)\)|don't\(\)|do\(\)/)
  end

  defp solve(pattern) do
    pattern
    |> Regex.scan(File.read!("lib/day03/input.txt"))
    |> Enum.reduce({0, true}, fn instruction, {sum, active} ->
      case instruction do
        [_, x, y] when active -> {sum + String.to_integer(x) * String.to_integer(y), true}
        ["do()"] -> {sum, true}
        ["don't()"] -> {sum, false}
        _ -> {sum, active}
      end
    end)
    |> elem(0)
  end
end
