defmodule Day10 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {tile, x} <- Enum.with_index(to_charlist(line)),
        into: %{} do
      {{x, y}, tile}
    end
  end

  def part_one(maze) do
    div(length(pipe(maze)), 2)
  end

  def pipe(maze) do
    [{x, y}] = for {pos, ?S} <- maze, do: pos

    next =
      cond do
        maze[{x - 1, y}] in ~c"F-L" -> {x - 1, y}
        maze[{x + 1, y}] in ~c"7-J" -> {x + 1, y}
        maze[{x, y - 1}] in ~c"7|F" -> {x, y - 1}
        maze[{x, y + 1}] in ~c"J|L" -> {x, y + 1}
      end

    flood_pipe(maze, next, [{x, y}])
  end

  def flood_pipe(maze, {x, y}, [prev | _] = seen) do
    if maze[{x, y}] == ?S do
      seen
    else
      next =
        case maze[{x, y}] do
          ?- -> [{x - 1, y}, {x + 1, y}]
          ?| -> [{x, y - 1}, {x, y + 1}]
          ?F -> [{x + 1, y}, {x, y + 1}]
          ?7 -> [{x - 1, y}, {x, y + 1}]
          ?J -> [{x - 1, y}, {x, y - 1}]
          ?L -> [{x + 1, y}, {x, y - 1}]
        end

      [pos] = next -- [prev]

      flood_pipe(maze, pos, [{x, y} | seen])
    end
  end
end

maze = Day10.parse(File.read!("input.txt"))
IO.puts(Day10.part_one(maze))
