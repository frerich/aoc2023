defmodule Day04 do
  def parse(input) do
    for card <- String.split(input, "\n", trim: true) do
      [_id, numbers] = String.split(card, ":")
      [winning, given] = String.split(numbers, "|")
      {String.split(winning), String.split(given)}
    end
  end

  def part_one(cards) do
    cards
    |> Enum.map(fn {winning, given} ->
      num_matches = Enum.count(winning, &(&1 in given))

      if num_matches == 0 do
        0
      else
        2 ** (num_matches - 1)
      end
    end)
    |> Enum.sum()
  end

  def part_two(cards) do
    cards = Enum.with_index(cards, 1)

    instances = Map.new(cards, fn {_card, id} -> {id, 1} end)

    instances =
      Enum.reduce(cards, instances, fn {{winning, given}, id}, instances ->
        num_matches = Enum.count(winning, &(&1 in given))

        if num_matches == 0 do
          instances
        else
          num_instances = Map.fetch!(instances, id)

          Enum.reduce((id + 1)..(id + num_matches), instances, fn id, instances ->
            Map.update!(instances, id, &(&1 + num_instances))
          end)
        end
      end)

    instances
    |> Map.values()
    |> Enum.sum()
  end
end

cards = Day04.parse(File.read!("input.txt"))
IO.puts(Day04.part_one(cards))
IO.puts(Day04.part_two(cards))
