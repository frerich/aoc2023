defmodule Day02 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      [<<"Game ", id::binary>>, sets] = String.split(line, ":")

      cubes =
        for set <- String.split(sets, ";"),
            cube <- String.split(set, ",") do
          case String.split(cube) do
            [n, "red"] -> {:red, String.to_integer(n)}
            [n, "green"] -> {:green, String.to_integer(n)}
            [n, "blue"] -> {:blue, String.to_integer(n)}
          end
        end

      {String.to_integer(id), cubes}
    end
  end

  def part_one(input) do
    games = parse(input)
    ids_of_impossible_games =
      for {game_id, cubes} <- games do
        reds = Keyword.get_values(cubes, :red)
        greens = Keyword.get_values(cubes, :green)
        blues = Keyword.get_values(cubes, :blue)
        if Enum.any?(reds, & &1 > 12) or Enum.any?(greens, & &1 > 13) or Enum.any?(blues, & &1 > 14) do
          0
        else
          game_id
        end
      end

    Enum.sum(ids_of_impossible_games)
  end

  def part_two(input) do
    games = parse(input)

    powers =
      for {_game_id, cubes} <- games do
        reds = Keyword.get_values(cubes, :red)
        greens = Keyword.get_values(cubes, :green)
        blues = Keyword.get_values(cubes, :blue)
        Enum.max(reds) * Enum.max(greens) * Enum.max(blues)
      end

    Enum.sum(powers)
  end
end

input = File.read!("input.txt")
IO.puts(Day02.part_one(input))
IO.puts(Day02.part_two(input))
