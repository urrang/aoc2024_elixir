defmodule Day09.Day09 do
  def parse_file() do
    File.read!("lib/day09/input.txt")
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {count, index} ->
      value = if rem(index, 2) == 0, do: div(index, 2), else: "."
      List.duplicate(value, count)
    end)
  end

  def part_1() do
    items = parse_file()
    file_count = Enum.count(Enum.reject(items, &(&1 == ".")))

    fill_from_back(items, Enum.reverse(items))
    |> Enum.take(file_count)
    |> Enum.with_index()
    |> Enum.map(fn {file_id, index} -> file_id * index end)
    |> Enum.sum()
  end

  defp fill_from_back([], _), do: []

  defp fill_from_back([block | rest], reversed) do
    if block == "." do
      {block, reversed} = get_from_back(reversed)
      [block | fill_from_back(rest, reversed)]
    else
      [block | fill_from_back(rest, reversed)]
    end
  end

  defp get_from_back(["." | rest]), do: get_from_back(rest)
  defp get_from_back([block | rest]), do: {block, rest}

  def part_2() do
    blocks =
      parse_file()
      |> Enum.chunk_by(& &1)
      |> Enum.reduce({[], 0}, fn chunk, {blocks, next_pos} ->
        size = length(chunk)
        block = {hd(chunk), next_pos, size}
        {[block | blocks], next_pos + size}
      end)
      |> elem(0)
      |> Enum.reverse()

    files_reversed =
      blocks
      |> Enum.filter(fn {value, _, _} -> value != "." end)
      |> Enum.reverse()

    empty_blocks =
      blocks
      |> Enum.filter(fn {value, _, _} -> value == "." end)
      |> Enum.map(fn {_, pos, size} -> {pos, size} end)

    defragment(files_reversed, empty_blocks)
    |> Enum.reduce(0, fn {id, pos, size}, checksum ->
      file_sum = Enum.sum(Enum.map(pos..(pos + size - 1), &(&1 * id)))
      checksum + file_sum
    end)
  end

  defp defragment([], _), do: []

  defp defragment([{value, pos, size} | rest], space_map) do
    case find_free_space(space_map, [], size, pos) do
      nil ->
        [{value, pos, size} | defragment(rest, space_map)]

      {new_pos, updated_map} ->
        updated_file = {value, new_pos, size}
        [updated_file | defragment(rest, updated_map)]
    end
  end

  defp find_free_space([], _, _, _), do: nil

  defp find_free_space([{pos, size} | rest], checked, file_size, file_pos) do
    if size >= file_size && pos < file_pos do
      updated_space = {pos + file_size, size - file_size}
      updated_map = Enum.reverse(checked) ++ [updated_space] ++ rest
      {pos, updated_map}
    else
      find_free_space(rest, [{pos, size} | checked], file_size, file_pos)
    end
  end
end
