defmodule D3 do

  def a() do
    Read_File_Utils.read_file("three.txt")
    |> expand_grid()
    |> IO.inspect()
    |> traverse({0, 0}, 0)
  end

  def traverse(grid, current_position, tree_count) do
    case coordinate_value(grid, current_position) do
      "x" -> tree_count
      _ -> current_position = next_coordinate(current_position)
           tree_count = increase_tree_count_when_tree(grid, current_position, tree_count)
           current_position = next_coordinate(current_position)
           tree_count = increase_tree_count_when_tree(grid, current_position, tree_count)
           current_position = next_coordinate(current_position)
           tree_count = increase_tree_count_when_tree(grid, current_position, tree_count)
           current_position = next_coordinate(current_position, true)
           tree_count = increase_tree_count_when_tree(grid, current_position, tree_count)
           traverse(grid, current_position, tree_count)
    end
  end

  def increase_tree_count_when_tree(grid, c, tree_count) do
    if(coordinate_contain_tree(grid, c)) do
      IO.puts("found tree at #{elem(c, 0)}:#{elem(c, 1)}")
      tree_count + 1
    else
      tree_count
    end
  end

  def next_coordinate(c, col \\ false) do
    case col do
      false -> put_elem(c, 0, elem(c, 0) + 1)
      true -> put_elem(c, 1, elem(c, 1) + 1)
    end
  end

  def coordinate_contain_tree(grid, c), do: coordinate_value(grid, c) == "#"

  def coordinate_value(grid, c),
      do:
        String.at(
          Enum.at(grid, elem(c, 1)),
          elem(c, 0)
        )

  def expand_grid(grid),
      do: Enum.map(
            grid,
            fn row -> row <> row <> row <> row <> row <> row <> row <> row <> row <> row <> row <> row <> row end
          ) ++ [
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
          ]

end