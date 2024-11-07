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
    IO.inspect(module_name.part_1(), label: "\nPart 1")
  end

  defp solve_part_2(module_name) do
    IO.inspect(module_name.part_2(), label: "\nPart 2")
  end

  defp solve_all(module_name) do
    solve_part_1(module_name)
    solve_part_2(module_name)
  end
end
