defmodule Day09 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end
  end

  def part_one(rows) do
    rows
    |> Enum.map(&(&1 |> triangle() |> value({length(&1), 0})))
    |> Enum.sum()
  end

  def part_two(rows) do
    rows
    |> Enum.map(&(&1 |> triangle() |> value({-1, 0})))
    |> Enum.sum()
  end

  def value(triangle, pos) when is_map_key(triangle, pos), do: triangle[pos]

  def value(triangle, {_x, y}) when not is_map_key(triangle, {0, y + 1}), do: triangle[{0, y}]

  def value(triangle, {x, y}) do
    if triangle[{x - 1, y}] do
      value(triangle, {x - 1, y}) + value(triangle, {x - 1, y + 1})
    else
      value(triangle, {x + 1, y}) - value(triangle, {x, y + 1})
    end
  end

  def triangle(row) do
    triangle_rows =
      row
      |> Stream.iterate(fn row -> Enum.zip_with(tl(row), row, &-/2) end)
      |> Enum.take_while(fn row -> Enum.any?(row, &(&1 != 0)) end)

    for {row, y} <- Enum.with_index(triangle_rows),
        {number, x} <- Enum.with_index(row),
        into: %{} do
      {{x, y}, number}
    end
  end
end

input = Day09.parse(File.read!("input.txt"))
IO.inspect(Day09.part_one(input))
IO.inspect(Day09.part_two(input))
