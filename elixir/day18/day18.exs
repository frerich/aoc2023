defmodule Day18 do
  def parse(input) do
    input
    |> String.split()
    |> Enum.chunk_every(3)
    |> Enum.map(fn
      ["R", dist, <<"(#", rgb::binary-6, ")">>] ->
        {{1, 0}, String.to_integer(dist), String.to_integer(rgb, 16)}

      ["L", dist, <<"(#", rgb::binary-6, ")">>] ->
        {{-1, 0}, String.to_integer(dist), String.to_integer(rgb, 16)}

      ["U", dist, <<"(#", rgb::binary-6, ")">>] ->
        {{0, -1}, String.to_integer(dist), String.to_integer(rgb, 16)}

      ["D", dist, <<"(#", rgb::binary-6, ")">>] ->
        {{0, 1}, String.to_integer(dist), String.to_integer(rgb, 16)}
    end)
  end

  def part_one(plan) do
    {exterior, {0, 0}} =
      Enum.reduce(plan, {[], {0, 0}}, fn
        {{dx, dy}, dist, _rgb}, {exterior, pos} ->
          edge = Enum.scan(1..dist, pos, fn _, {x, y} -> {x + dx, y + dy} end)
          {edge ++ exterior, List.last(edge)}
      end)

    filled = flood([{-1, -1}], MapSet.new(exterior))

    MapSet.size(filled)
  end

  def flood([], seen), do: seen

  def flood([{x, y} | rest], seen) do
    if MapSet.member?(seen, {x, y}) do
      flood(rest, seen)
    else
      seen = MapSet.put(seen, {x, y})
      next = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
      flood(rest ++ next, seen)
    end
  end
end

plan = Day18.parse(File.read!("input.txt"))
IO.puts(Day18.part_one(plan))
