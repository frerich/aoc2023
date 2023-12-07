defmodule Day07 do
  @types ~w[high_card one_pair two_pairs three_of_a_kind full_house four_of_a_kind five_of_a_kind]a

  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      [hand, bid] = String.split(line)
      {to_charlist(hand), String.to_integer(bid)}
    end
  end

  def part_one(input) do
    labels = ~c"23456789TJQKA"

    input
    |> Enum.sort_by(fn {hand, _bid} ->
      type = Enum.find_index(@types, &(&1 == type(hand)))
      cards = for card <- hand, do: Enum.find_index(labels, &(&1 == card))
      {type, cards}
    end)
    |> Enum.with_index(fn {_hand, bid}, index -> (index + 1) * bid end)
    |> Enum.sum()
  end

  def part_two(input) do
    labels = ~c"J23456789TQKA"

    input
    |> Enum.sort_by(fn {hand, _bid} ->
      type = Enum.find_index(@types, &(&1 == type(replace_jokers(hand, labels))))
      cards = for card <- hand, do: Enum.find_index(labels, &(&1 == card))
      {type, cards}
    end)
    |> Enum.with_index(fn {_hand, bid}, index -> (index + 1) * bid end)
    |> Enum.sum()
  end

  def replace_jokers(~c"JJJJJ", _labels) do
    ~c"AAAAA"
  end

  def replace_jokers(hand, labels) do
    # Replace all jokers in hand with what seems to be the most useful card.
    {replacement, _count} =
      hand
      |> Enum.filter(&(&1 != ?J))
      |> Enum.frequencies()
      |> Enum.max_by(fn {label, count} -> {count, Enum.find_index(labels, &(&1 == label))} end)

    Enum.map(hand, fn
      ?J -> replacement
      label -> label
    end)
  end

  def type(hand) do
    frequencies = hand |> Enum.frequencies() |> Map.values() |> Enum.sort()

    case frequencies do
      [5] -> :five_of_a_kind
      [1, 4] -> :four_of_a_kind
      [2, 3] -> :full_house
      [1, 1, 3] -> :three_of_a_kind
      [1, 2, 2] -> :two_pairs
      [1, 1, 1, 2] -> :one_pair
      [1, 1, 1, 1, 1] -> :high_card
    end
  end
end

input = Day07.parse(File.read!("input.txt"))
IO.puts(Day07.part_one(input))
IO.puts(Day07.part_two(input))
