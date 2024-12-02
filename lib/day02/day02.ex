defmodule Day02.Day02 do
  def parse_file() do
    File.read!("lib/day02/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_1() do
    parse_file()
    |> Enum.filter(&check_report/1)
    |> Enum.count()
  end

  def part_2() do
    parse_file()
    |> Enum.filter(fn report ->
      0..length(report)
      |> Enum.map(fn i -> List.delete_at(report, i) end)
      |> Enum.any?(&check_report/1)
    end)
    |> Enum.count()
  end

  defp check_report(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a - b end)
    |> check_diffs()
  end

  defp check_diffs([head | []]), do: abs(head) > 0 and abs(head) < 4

  defp check_diffs([head | tail]) do
    head * hd(tail) > 0 and abs(head) < 4 and check_diffs(tail)
  end
end
