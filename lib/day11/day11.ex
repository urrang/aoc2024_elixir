defmodule Day11.Day11 do
  def parse_file() do
    File.read!("lib/day11/input.txt")
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part_1() do
    create_ets_table()

    parse_file()
    |> Enum.map(&count(25, &1))
    |> Enum.sum()
  end

  def part_2() do
    create_ets_table()

    parse_file()
    |> Enum.map(&count(75, &1))
    |> Enum.sum()
  end

  defp count(0, _), do: 1
  defp count(n, 0), do: count(n - 1, 1)

  defp count(n, stone) do
    case :ets.lookup(:day11_cache, {n, stone}) do
      [{_, count}] ->
        count

      [] ->
        str = to_string(stone)
        len = String.length(str)

        count =
          if rem(len, 2) == 0,
            do: split_and_count(n - 1, str, len),
            else: count(n - 1, stone * 2024)

        :ets.insert(:day11_cache, {{n, stone}, count})
        count
    end
  end

  defp split_and_count(n, str, len) do
    mid = div(len, 2)
    left = String.to_integer(String.slice(str, 0, mid))
    right = String.to_integer(String.slice(str, mid, len))

    count(n, left) + count(n, right)
  end

  defp create_ets_table() do
    if :ets.info(:day11_cache) == :undefined do
      :ets.new(:day11_cache, [:named_table])
    end
  end
end
