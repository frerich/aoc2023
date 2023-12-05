defmodule Day05 do
  def parse(input) do
    ["seeds: " <> seeds | mappings] = String.split(input, "\n\n", trim: true)

    mappings =
      for mapping <- mappings do
        [_heading | rows] = String.split(mapping, "\n", trim: true)
        for row <- rows, do: parse_numbers(row)
      end

    {parse_numbers(seeds), mappings}
  end

  defp parse_numbers(binary) do
    binary |> String.split() |> Enum.map(&String.to_integer/1)
  end

  def part_one({seeds, mappings}) do
    location_numbers =
      for seed <- seeds do
        Enum.reduce(mappings, seed, fn mapping, id ->
          Enum.find_value(mapping, id, fn [dst_range_start, src_range_start, range_length] ->
            if id in src_range_start..(src_range_start + range_length - 1) do
              id - src_range_start + dst_range_start
            end
          end)
        end)
      end

    Enum.min(location_numbers)
  end

  def part_two({seeds, mappings}) do
    seed_intervals =
      for [start, length] <- Enum.chunk_every(seeds, 2) do
        start..(start + length - 1)
      end

    window_size = 1024

    window_start =
      0
      |> Stream.iterate(&(&1 + window_size))
      |> find_first_location_number(seed_intervals, mappings)

    (window_start - window_size)
    |> Stream.iterate(&(&1 + 1))
    |> find_first_location_number(seed_intervals, mappings)
  end

  def find_first_location_number(location_numbers, seed_intervals, mappings) do
    Enum.find(location_numbers, fn location_number ->
      seed =
        mappings
        |> Enum.reverse()
        |> Enum.reduce(location_number, fn mapping, id ->
          Enum.find_value(mapping, id, fn [dst_range_start, src_range_start, range_length] ->
            if id in dst_range_start..(dst_range_start + range_length - 1) do
              id - dst_range_start + src_range_start
            end
          end)
        end)

      Enum.any?(seed_intervals, &(seed in &1))
    end)
  end
end

almanac = Day05.parse(File.read!("input.txt"))
IO.puts(Day05.part_one(almanac))
IO.puts(Day05.part_two(almanac))
