defmodule Day12 do
  def parse(input) do
    for row <- String.split(input, "\n", trim: true) do
      [springs, lengths] = String.split(row)
      lengths = lengths |> String.split(",") |> Enum.map(&String.to_integer/1)
      {to_charlist(springs), lengths}
    end
  end

  def part_one(rows) do
    rows
    |> Enum.map(fn {springs, lengths} -> count_legal_arrangements(springs, lengths) end)
    |> Enum.sum()
  end

  def count_legal_arrangements(springs, lengths) do
    num_operational_required = Enum.count(springs) - Enum.sum(lengths)
    num_operational_given = Enum.count(springs, & &1 == ?.)

    unknowns_at = for {??, i} <- Enum.with_index(springs), do: i

    unknowns_at
    |> draw(num_operational_required - num_operational_given)
    |> Enum.map(fn indices ->
      Enum.reduce(indices, springs, fn i, springs -> List.replace_at(springs, i, ?.) end)
    end)
    |> Enum.count(fn s ->
      s |> Enum.chunk_by(& &1 == ?.) |> Enum.reject(& hd(&1) == ?.) |> is_legal_arrangement(lengths)
    end)
  end

  def draw(_, 0), do: [[]]
  def draw([], _), do: []
  def draw([x|xs], n) do
    (for y <- draw(xs, n - 1), do: [x|y]) ++ draw(xs, n)
  end

  def is_legal_arrangement([], []), do: true
  def is_legal_arrangement([g | gs], [n | ns]), do: length(g) == n and is_legal_arrangement(gs, ns)
  def is_legal_arrangement(_, _), do: false
end

input = Day12.parse(File.read!("input.txt"))
IO.puts(Day12.part_one(input))
