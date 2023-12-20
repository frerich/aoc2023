defmodule Day19 do
  def parse(input) do
    [workflows, parts] = String.split(input, "\n\n", trim: true)

    workflows =
      for workflow <- String.split(workflows, "\n"), into: %{} do
        [name, rules] = String.split(workflow, ~r/[{}]/, trim: true)

        rules =
          for rule <- String.split(rules, ",") do
            case String.split(rule, ":") do
              [condition, outcome] ->
                case condition do
                  <<category, ?>, value::binary>> -> fn part -> if part[category] > String.to_integer(value), do: outcome end
                  <<category, ?<, value::binary>> -> fn part -> if part[category] < String.to_integer(value), do: outcome end
                end

              [outcome] ->
                fn _part -> outcome end
            end
          end

        {name, rules}
      end

    parts =
      for line <- String.split(parts, "\n") do
        ratings = line |> String.trim_leading("{") |> String.trim_trailing("}")

        for <<category, ?=, value::binary>> <- String.split(ratings, ","), into: %{} do
          {category, String.to_integer(value)}
        end
      end

    {workflows, parts}
  end

  def part_one({workflows, parts}) do
    parts
    |> Enum.filter(& eval(workflows, "in", &1) == "A")
    |> Enum.map(& Enum.sum(Map.values(&1)))
    |> Enum.sum()
  end

  def eval(_workflows, "A", _part), do: "A"
  def eval(_workflows, "R", _part), do: "R"
  def eval(workflows, state, part) do
    eval(workflows, Enum.find_value(workflows[state], fn rule -> rule.(part) end), part)
  end
end

input = Day19.parse(File.read!("input.txt"))
IO.puts(Day19.part_one(input))

