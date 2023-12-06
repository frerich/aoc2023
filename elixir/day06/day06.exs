defmodule Day06 do
  def parse(input) do
    ["Time:" <> times, "Distance:" <> distances] = String.split(input, "\n", trim: true)

    {times, distances}
  end

  def part_one({times, distances}) do
    times = times |> String.split() |> Enum.map(&String.to_integer/1)
    distances = distances |> String.split() |> Enum.map(&String.to_integer/1)

    times
    |> Enum.zip_with(distances, fn race_time, best_distance ->
      count_ways_to_win(race_time, best_distance)
    end)
    |> Enum.product()
  end

  def part_two({times, distances}) do
    race_time = times |> String.replace(" ", "") |> String.to_integer()
    best_distance = distances |> String.replace(" ", "") |> String.to_integer()
    count_ways_to_win(race_time, best_distance)
  end

  defp count_ways_to_win(race_time, best_distance) do
    Enum.count(0..race_time, fn time_pressed ->
      distance_travelled = (race_time - time_pressed) * time_pressed
      distance_travelled > best_distance
    end)
  end
end

input = Day06.parse(File.read!("input.txt"))
IO.puts(Day06.part_one(input))
IO.puts(Day06.part_two(input))
