defmodule Day17.Day17 do
  import Bitwise

  @op_codes %{
    nil => :halt,
    0 => :adv,
    1 => :bxl,
    2 => :bst,
    3 => :jnz,
    4 => :bxc,
    5 => :out,
    6 => :bdv,
    7 => :cdv
  }

  def parse_file() do
    [[a, b, c], program] =
      File.read!("lib/day17/input.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn str -> Regex.scan(~r/-?\d+/, str) end)
      |> Enum.map(fn chunk ->
        chunk
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)

    program =
      program
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {num, index}, map -> Map.put(map, index, num) end)

    {%{a: a, b: b, c: c}, program}
  end

  def part_1() do
    {registers, program} = parse_file()

    Enum.join(run(registers, program), ",")
  end

  def part_2() do
    {_, program} = parse_file()

    program_str =
      program
      |> Enum.map(fn {_, x} -> x end)
      |> Enum.join("")

    find_a(program, program_str, 1)
  end

  defp run(registers, program, pointer \\ 0) do
    operation = @op_codes[program[pointer]]
    literal = program[pointer + 1]
    combo = combo_operand(registers, literal)

    case operation do
      :halt ->
        []

      :adv ->
        run(div(registers, :a, combo), program, pointer + 2)

      :bxl ->
        registers = Map.put(registers, :b, bxor(registers[:b], literal))
        run(registers, program, pointer + 2)

      :bst ->
        registers = Map.put(registers, :b, rem(combo, 8))
        run(registers, program, pointer + 2)

      :jnz ->
        pointer = if registers[:a] == 0, do: pointer + 2, else: literal
        run(registers, program, pointer)

      :bxc ->
        registers = Map.put(registers, :b, bxor(registers[:b], registers[:c]))
        run(registers, program, pointer + 2)

      :out ->
        [rem(combo, 8) | run(registers, program, pointer + 2)]

      :bdv ->
        run(div(registers, :b, combo), program, pointer + 2)

      :cdv ->
        run(div(registers, :c, combo), program, pointer + 2)
    end
  end

  defp combo_operand(registers, 4), do: registers[:a]
  defp combo_operand(registers, 5), do: registers[:b]
  defp combo_operand(registers, 6), do: registers[:c]
  defp combo_operand(_, literal), do: literal

  defp div(registers, into, operand) do
    exponent = if operand == 5, do: registers[:b], else: operand
    Map.put(registers, into, floor(registers[:a] / :math.pow(2, exponent)))
  end

  defp find_a(program, program_str, a) do
    res = Enum.join(run(%{a: a, b: 0, c: 0}, program), "")

    cond do
      res == program_str -> a
      String.ends_with?(program_str, res) -> find_a(program, program_str, a * 8)
      true -> find_a(program, program_str, a + 1)
    end
  end
end
