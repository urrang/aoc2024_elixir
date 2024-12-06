defmodule Mix.Tasks.Solve do
  use Mix.Task

  @shortdoc "Runs a specified part of the Advent of Code for a given day"
  @moduledoc "Example: `mix solve 1:2` for day 1 part 2, or `mix solve 1` for both tasks on day 1"

  def run([day]) do
    run([day, :all])
  end

  def run([day, part]) do
    day = String.pad_leading(day, 2, "0")
    module_name = String.to_atom("Elixir.Day#{day}.Day#{day}")

    if Code.ensure_loaded?(module_name) do
      case part do
        "1" -> solve_part_1(module_name)
        "2" -> solve_part_2(module_name)
        :all -> solve_all(module_name)
      end
    else
      IO.puts("Module for day #{day} not found")
    end
  end

  defp solve_part_1(module_name) do
    {time, result} = :timer.tc(&module_name.part_1/0)
    IO.puts("\nPart 1 (#{format_duration(time)})")
    IO.inspect(result)
  end

  defp solve_part_2(module_name) do
    {time, result} = :timer.tc(&module_name.part_2/0)
    IO.puts("\nPart 2 (#{format_duration(time)})")
    IO.inspect(result)
  end

  defp solve_all(module_name) do
    solve_part_1(module_name)
    solve_part_2(module_name)
  end

  defp format_duration(us) when is_integer(us) do
    cond do
      us < 1_000 ->
        # Microseconds
        "#{us} µs"

      us < 1_000_000 ->
        ms = us / 1_000
        "#{Float.round(ms, 2)} ms"

      true ->
        s = us / 1_000_000
        "#{Float.round(s, 2)} seconds"
    end
  end
end
