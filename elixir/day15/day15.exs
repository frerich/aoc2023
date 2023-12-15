defmodule Day15 do
  def parse(input) do
    String.split(String.trim(input), ",")
  end

  def part_one(steps) do
    steps
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def part_two(steps) do
    boxes =
      steps
      |> Enum.map(fn step -> String.split(step, ~r/[-=]/, include_captures: true, trim: true) end)
      |> Enum.reduce(%{}, &step/2)

    focusing_powers =
      for {box_id, lenses} <- boxes,
          {{_label, focal_length}, slot} <- Enum.with_index(lenses, 1) do
        (box_id + 1) * slot * String.to_integer(focal_length)
      end

    Enum.sum(focusing_powers)
  end

  def step([label, "-"], boxes) do
    Map.update(boxes, hash(label), [], fn box ->
      case Enum.find_index(box, fn {l, _} -> l == label end) do
        nil -> box
        index -> List.delete_at(box, index)
      end
    end)
  end

  def step([label, "=", focal_length], boxes) do
    Map.update(boxes, hash(label), [{label, focal_length}], fn box ->
      case Enum.find_index(box, fn {l, _} -> l == label end) do
        nil -> box ++ [{label, focal_length}]
        index -> List.replace_at(box, index, {label, focal_length})
      end
    end)
  end

  def hash(binary), do: hash(binary, 0)
  def hash(<<>>, acc), do: acc
  def hash(<<ch, rest::binary>>, acc), do: hash(rest, rem((acc + ch) * 17, 256))
end

steps = Day15.parse(File.read!("input.txt"))
IO.puts(Day15.part_one(steps))
IO.puts(Day15.part_two(steps))
