defmodule Day03 do
  def parse(input, {{x, y}, symbols, numbers}) do
    case input do
      <<>> ->
        {symbols, numbers}

      <<?., rest::binary>> ->
        parse(rest, {{x + 1, y}, symbols, numbers})

      <<?\n, rest::binary>> ->
        parse(rest, {{0, y + 1}, symbols, numbers})

      <<digit, _rest::binary>> when digit in ?0..?9 ->
        {number, _} = Integer.parse(input)
        number_length = String.length("#{number}")
        {_, rest} = String.split_at(input, number_length)
        parse(rest, {{x + number_length, y}, symbols, [{{x, y}, number} | numbers]})

      <<symbol, rest::binary>> ->
        parse(rest, {{x + 1, y}, [{{x, y}, symbol} | symbols], numbers})
    end
  end

  def part_one({symbols, numbers}) do
    numbers
    |> Enum.filter(fn number ->
      Enum.any?(symbols, fn symbol -> adjacent?(number, symbol) end)
    end)
    |> Enum.map(fn {_pos, value} -> value end)
    |> Enum.sum()
  end

  def part_two({symbols, numbers}) do
    gear_ratios =
      for {_pos, ?*} = gear_symbol <- symbols do
        part_numbers = Enum.filter(numbers, fn number -> adjacent?(number, gear_symbol) end)

        case part_numbers do
          [{_, gear_1}, {_, gear_2}] -> gear_1 * gear_2
          _ -> 0
        end
      end

    Enum.sum(gear_ratios)
  end

  defp adjacent?({{num_x, num_y}, number}, {{sym_x, sym_y}, _}) do
    sym_x in (num_x - 1)..(num_x + String.length("#{number}")) and
      sym_y in (num_y - 1)..(num_y + 1)
  end
end

input = File.read!("input.txt") |> Day03.parse({{0, 0}, [], []})
IO.inspect(part_one: Day03.part_one(input), part_two: Day03.part_two(input))
