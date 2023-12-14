defmodule Day14 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {cell, x} <- Enum.with_index(to_charlist(line)),
        cell in ~c"O#",
        into: %{} do
      {{x, y}, cell}
    end
  end

  def part_one(platform) do
    platform
    |> tilt(:north)
    |> load_on_north_beams()
  end

  def part_two(platform) do
    period = find_loop(platform)

    num_iterations = rem(1_000_000_000, period) + period

    platform
    |> Stream.iterate(&spin/1)
    |> Enum.at(num_iterations)
    |> load_on_north_beams()
  end

  def find_loop(platform, {iteration, seen} \\ {0, %{}}) do
    if Map.has_key?(seen, platform) do
      iteration - seen[platform]
    else
      find_loop(spin(platform), {iteration + 1, Map.put(seen, platform, iteration)})
    end
  end

  def spin(platform) do
    platform
    |> tilt(:north)
    |> tilt(:west)
    |> tilt(:south)
    |> tilt(:east)
  end

  def tilt(platform, :north) do
    max_y = Enum.max(for {{_x, y}, _} <- platform, do: y)

    Enum.reduce(0..max_y, platform, fn y, platform ->
      rocks_in_row = for {{x, ^y}, ?O} <- platform, do: {x, y}

      Enum.reduce(rocks_in_row, platform, fn {rx, ry}, platform ->
        platform = Map.delete(platform, {rx, ry})

        new_y =
          Enum.find((y - 1)..-1, fn new_y ->
            Map.has_key?(platform, {rx, new_y}) || new_y == -1
          end)

        Map.put(platform, {rx, new_y + 1}, ?O)
      end)
    end)
  end

  def tilt(platform, :south) do
    max_y = Enum.max(for {{_x, y}, _} <- platform, do: y)

    Enum.reduce(max_y..0, platform, fn y, platform ->
      rocks_in_row = for {{x, ^y}, ?O} <- platform, do: {x, y}

      Enum.reduce(rocks_in_row, platform, fn {rx, ry}, platform ->
        platform = Map.delete(platform, {rx, ry})

        new_y =
          Enum.find((y + 1)..(max_y + 1), fn new_y ->
            Map.has_key?(platform, {rx, new_y}) || new_y == max_y + 1
          end)

        Map.put(platform, {rx, new_y - 1}, ?O)
      end)
    end)
  end

  def tilt(platform, :west) do
    max_x = Enum.max(for {{x, _y}, _} <- platform, do: x)

    Enum.reduce(0..max_x, platform, fn x, platform ->
      rocks_in_col = for {{^x, y}, ?O} <- platform, do: {x, y}

      Enum.reduce(rocks_in_col, platform, fn {rx, ry}, platform ->
        platform = Map.delete(platform, {rx, ry})

        new_x =
          Enum.find((x - 1)..-1, fn new_x ->
            Map.has_key?(platform, {new_x, ry}) || new_x == -1
          end)

        Map.put(platform, {new_x + 1, ry}, ?O)
      end)
    end)
  end

  def tilt(platform, :east) do
    max_x = Enum.max(for {{x, _y}, _} <- platform, do: x)

    Enum.reduce(max_x..0, platform, fn x, platform ->
      rocks_in_col = for {{^x, y}, ?O} <- platform, do: {x, y}

      Enum.reduce(rocks_in_col, platform, fn {rx, ry}, platform ->
        platform = Map.delete(platform, {rx, ry})

        new_x =
          Enum.find((x + 1)..(max_x + 1), fn new_x ->
            Map.has_key?(platform, {new_x, ry}) || new_x == max_x + 1
          end)

        Map.put(platform, {new_x - 1, ry}, ?O)
      end)
    end)
  end

  def load_on_north_beams(platform) do
    height = Enum.max(for {{_x, y}, _} <- platform, do: y) + 1

    Enum.sum(for {{_x, y}, ?O} <- platform, do: height - y)
  end

  def render(platform) do
    max_x = Enum.max(for {{x, _y}, _} <- platform, do: x)
    max_y = Enum.max(for {{_x, y}, _} <- platform, do: y)

    for y <- 0..max_y do
      for x <- 0..max_x do
        cell = Map.get(platform, {x, y}, ?.)
        IO.write(<<cell>>)
      end

      IO.write("\n")
    end
  end
end

platform = Day14.parse(File.read!("input.txt"))
IO.puts(Day14.part_one(platform))
IO.puts(Day14.part_two(platform))
