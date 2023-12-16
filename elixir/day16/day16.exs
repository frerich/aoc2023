defmodule Day16 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {tile, x} <- Enum.with_index(to_charlist(line)),
        into: %{} do
      {{x, y}, tile}
    end
  end

  def part_one(grid) do
    count_tiles_energized(grid, {{0, 0}, {1, 0}})
  end

  def part_two(grid) do
    max_x = Enum.max(for {{x, _y}, _tile} <- grid, do: x)
    max_y = Enum.max(for {{_x, y}, _tile} <- grid, do: y)

    starts =
      Enum.flat_map(0..max_x, fn x -> [{{x, 0}, {0, 1}}, {{x, max_y}, {0, -1}}] end) ++
        Enum.flat_map(1..(max_y - 1), fn y -> [{{0, y}, {1, 0}}, {{max_x, y}, {-1, 0}}] end)

    starts
    |> Enum.map(fn beam -> count_tiles_energized(grid, beam) end)
    |> Enum.max()
  end

  def count_tiles_energized(grid, beam) do
    grid
    |> trace([beam], MapSet.new())
    |> Enum.uniq_by(fn {pos, _vector} -> pos end)
    |> Enum.count()
  end

  def trace(_grid, [], seen) do
    seen
  end

  def trace(grid, [beam | rest], seen) do
    {{x, y} = pos, vector} = beam

    cond do
      not Map.has_key?(grid, pos) ->
        trace(grid, rest, seen)

      MapSet.member?(seen, beam) ->
        trace(grid, rest, seen)

      true ->
        seen = MapSet.put(seen, beam)
        next = for {vx, vy} <- next(vector, grid[pos]), do: {{x + vx, y + vy}, {vx, vy}}
        trace(grid, rest ++ next, seen)
    end
  end

  def next({vx, vy}, ?.), do: [{vx, vy}]
  def next({vx, 0}, ?-), do: [{vx, 0}]
  def next({0, vy}, ?|), do: [{0, vy}]
  def next({_vx, _vy}, ?-), do: [{-1, 0}, {1, 0}]
  def next({_vx, _vy}, ?|), do: [{0, -1}, {0, 1}]
  def next({1, 0}, ?/), do: [{0, -1}]
  def next({0, -1}, ?/), do: [{1, 0}]
  def next({-1, 0}, ?/), do: [{0, 1}]
  def next({0, 1}, ?/), do: [{-1, 0}]
  def next({1, 0}, ?\\), do: [{0, 1}]
  def next({0, -1}, ?\\), do: [{-1, 0}]
  def next({-1, 0}, ?\\), do: [{0, -1}]
  def next({0, 1}, ?\\), do: [{1, 0}]
end

grid = Day16.parse(File.read!("input.txt"))
IO.puts(Day16.part_one(grid))
IO.puts(Day16.part_two(grid))
