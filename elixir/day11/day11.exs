defmodule Day11 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {cell, x} <- Enum.with_index(to_charlist(line)),
        cell == ?# do
      {x, y}
    end
  end

  def part_one(image) do
    image
    |> expand(2)
    |> transpose()
    |> expand(2)
    |> pairs()
    |> Enum.map(fn {{x0, y0}, {x1, y1}} -> abs(x0 - x1) + abs(y0 - y1) end)
    |> Enum.sum()
  end

  def part_two(image) do
    image
    |> expand(1_000_000)
    |> transpose()
    |> expand(1_000_000)
    |> pairs()
    |> Enum.map(fn {{x0, y0}, {x1, y1}} -> abs(x0 - x1) + abs(y0 - y1) end)
    |> Enum.sum()
  end

  def expand(image, n) do
    max_y = image |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    {rows, _increment} =
      Enum.reduce(0..max_y, {[], 0}, fn y, {rows, increment} ->
        row = for {x, ^y} <- image, do: {x, y}

        case row do
          [] ->
            {rows, increment + n - 1}

          row ->
            row = for {x, y} <- row, do: {x, y + increment}
            {[row | rows], increment}
        end
      end)

    Enum.concat(rows)
  end

  def transpose(list) do
    for {x, y} <- list, do: {y, x}
  end

  def pairs([]), do: []

  def pairs([a | tail]) do
    for(b <- tail, do: {a, b}) ++ pairs(tail)
  end
end

input = Day11.parse(File.read!("input.txt"))
IO.inspect(Day11.part_one(input))
IO.inspect(Day11.part_two(input))