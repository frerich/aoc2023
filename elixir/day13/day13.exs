defmodule Day13 do
  def parse(input) do
    for pattern <- String.split(input, "\n\n", trim: true) do
      for row <- String.split(pattern, "\n") do
        to_charlist(row)
      end
    end
  end

  def part_one(patterns) do
    patterns
    |> Enum.map(fn pattern ->
      pattern |> reflection_lines() |> List.first() |> score()
    end)
    |> Enum.sum()
  end

  def part_two(patterns) do
    patterns
    |> Enum.map(fn pattern ->
      initial_line = pattern |> reflection_lines() |> List.first()

      pattern
      |> variants()
      |> Enum.find_value(fn variant ->
        line = variant |> reflection_lines() |> Enum.find(&(&1 != initial_line))

        if line do
          score(line)
        end
      end)
    end)
    |> Enum.sum()
  end

  def reflection_lines(pattern) do
    horizontal_mirrors =
      pattern |> horizontal_reflection_indices() |> Enum.map(fn x -> {:horizontal, x} end)

    pattern = Enum.zip_with(pattern, & &1)

    vertical_mirrors =
      pattern |> horizontal_reflection_indices() |> Enum.map(fn x -> {:vertical, x} end)

    vertical_mirrors ++ horizontal_mirrors
  end

  def horizontal_reflection_indices(pattern) do
    height = length(pattern)

    1..(height - 1)
    |> Enum.filter(fn y ->
      {top, bottom} = Enum.split(pattern, y)
      top |> Enum.reverse() |> Enum.zip(bottom) |> Enum.all?(fn {a, b} -> a == b end)
    end)
  end

  def variants(pattern) do
    width = length(hd(pattern))
    height = length(pattern)

    for y <- 0..(height - 1), x <- 0..(width - 1) do
      List.update_at(pattern, y, fn row ->
        List.update_at(row, x, fn
          ?# -> ?.
          ?. -> ?#
        end)
      end)
    end
  end

  def score({:vertical, rows_above}), do: rows_above
  def score({:horizontal, rows_left}), do: rows_left * 100
end

patterns = Day13.parse(File.read!("input.txt"))
IO.puts(Day13.part_one(patterns))
IO.puts(Day13.part_two(patterns))
