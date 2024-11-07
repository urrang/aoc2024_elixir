defmodule Mix.Tasks.GenDay do
  use Mix.Task
  @shortdoc "Creates new files for a given Advent of Code day"

  @moduledoc "Example: `mix gen_day 1`"

  def run([day]) do
    Mix.Task.run("app.config")

    day = String.pad_leading(day, 2, "0")
    dir_path = "lib/day#{day}"
    file_path = "#{dir_path}/day#{day}.ex"

    if File.exists?(file_path) do
      IO.puts("Files for day #{day} already exist")
    else
      File.mkdir_p!(dir_path)
      File.write!(file_path, day_module_template(day))
      File.write!(Path.join(dir_path, "example.txt"), "")
      File.write!(Path.join(dir_path, "input.txt"), "")
      IO.puts("Created Advent of Code files for day #{day}")
    end
  end

  defp day_module_template(day) do
    """
    defmodule Day#{day}.Day#{day} do
      def parse_file() do
        File.read!("lib/day#{day}/example.txt")
        |> String.split("\\n", trim: true)
      end

      def part_1() do
        parse_file()
      end

      def part_2() do
        parse_file()
      end
    end
    """
  end
end
