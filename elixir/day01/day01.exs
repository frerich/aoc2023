defmodule Day01 do
  def example do
    """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """
  end

  def example2 do
    """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
  end

  def part_one(input) do
    calibration_values =
      for line <- String.split(input) do
        digits =
          line
          |> String.replace(~r/[^0-9]/, "")
          |> String.to_integer()
          |> Integer.digits()

        Enum.at(digits, 0) * 10 + Enum.at(digits, -1)
      end

    Enum.sum(calibration_values)
  end

  def part_two(input) do
    calibration_values =
      for line <- String.split(input) do
        digits = parse_digits(line, [])
        Enum.at(digits, 0) * 10 + Enum.at(digits, -1)
      end

    Enum.sum(calibration_values)
  end

  def parse_digits("", digits), do: Enum.reverse(digits)
  def parse_digits(<<digit, rest::binary>>, digits) when digit in ?0..?9 do
    parse_digits(rest, [digit - ?0 | digits])
  end
  def parse_digits(<<_, rest::binary>> = line, digits) do
    case line do
      <<"one", _::binary>> -> parse_digits(rest, [1 | digits])
      <<"two", _::binary>> -> parse_digits(rest, [2 | digits])
      <<"three", _::binary>> -> parse_digits(rest, [3 | digits])
      <<"four", _::binary>> -> parse_digits(rest, [4 | digits])
      <<"five", _::binary>> -> parse_digits(rest, [5 | digits])
      <<"six", _::binary>> -> parse_digits(rest, [6 | digits])
      <<"seven", _::binary>> -> parse_digits(rest, [7 | digits])
      <<"eight", _::binary>> -> parse_digits(rest, [8 | digits])
      <<"nine", _::binary>> -> parse_digits(rest, [9 | digits])
      _ -> parse_digits(rest, digits)
    end
  end
end

input = File.read!("input.txt")

IO.puts(Day01.part_one(input))
IO.puts(Day01.part_two(input))
