defmodule Day08 do
  def parse(input) do
    [instructions, nodes] = String.split(input, "\n\n", trim: true)

    nodes =
      for line <- String.split(nodes, "\n", trim: true), into: %{} do
        <<node::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">> =
          line

        {node, {left, right}}
      end

    {to_charlist(instructions), nodes}
  end

  def part_one({instructions, nodemap}) do
    distance(instructions, nodemap, "AAA", &(&1 == "ZZZ")) + 1
  end

  def part_two({instructions, nodemap}) do
    distances =
      for <<_, _, "A">> = start <- Map.keys(nodemap) do
        distance(instructions, nodemap, start, &match?(<<_, _, "Z">>, &1)) + 1
      end

    Enum.reduce(distances, &lcm/2)
  end

  def distance(instructions, nodemap, start, goal_fun) do
    instructions
    |> Stream.cycle()
    |> Stream.scan(start, fn
      ?L, node -> elem(nodemap[node], 0)
      ?R, node -> elem(nodemap[node], 1)
    end)
    |> Enum.find_index(&goal_fun.(&1))
  end

  # Taken from https://programming-idioms.org/idiom/75/compute-lcm/983/elixir
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))
end

input = Day08.parse(File.read!("input.txt"))
IO.puts(Day08.part_one(input))
IO.puts(Day08.part_two(input))
