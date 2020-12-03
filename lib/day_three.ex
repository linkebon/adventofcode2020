defmodule D3 do

  def a() do
    Read_File_Utils.read_file("three.txt")
    |> expand_grid()
    |> traverse(
         {0, 0},
         &(next_coordinate(&1)
           |> next_coordinate()
           |> next_coordinate()
           |> next_coordinate(true))
       )
    |> IO.inspect(label: "Slope two")
  end

  def b() do
    grid = Read_File_Utils.read_file("three.txt")
           |> expand_grid()
    #Right 1, down 1.
    slope1 = grid
             |> traverse(
                  {0, 0},
                  &(next_coordinate(&1)
                    |> next_coordinate(true)
                    )
                )

    #Right 3, down 1.
    slope2 = grid
             |> traverse(
                  {0, 0},
                  &(next_coordinate(&1)
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate(true))
                )

    #Right 5, down 1.
    slope3 = grid
             |> traverse(
                  {0, 0},
                  &(next_coordinate(&1)
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate(true))
                )

    #Right 7, down 1.
    slope4 = grid
             |> traverse(
                  {0, 0},
                  &(next_coordinate(&1)
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate()
                    |> next_coordinate(true))
                )

    #Right 1, down 2.
    slope5 = grid
             |> traverse(
                  {0, 0},
                  &(next_coordinate(&1)
                    |> next_coordinate(true)
                    |> next_coordinate(true))
                )
    slope1 * slope2 * slope3 * slope4 * slope5
  end

  def traverse(grid, current_position, traverse_instructions, tree_count \\ 0) do
    case coordinate_value(grid, current_position) do
      "x" ->
        tree_count
      _ ->
        current_position = traverse_instructions.(current_position)
        tree_count = increase_tree_count_when_tree(grid, current_position, tree_count)
        traverse(grid, current_position, traverse_instructions, tree_count)
    end
  end

  def increase_tree_count_when_tree(grid, c, tree_count) do
    if(coordinate_contain_tree(grid, c)) do
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

  def coordinate_contain_tree(grid, c), do: coordinate_value(grid, c) === "#"

  def coordinate_value(grid, c),
      do:
        String.at(
          Enum.at(grid, elem(c, 1)),
          elem(c, 0)
        )

  def expand_grid(grid),
      do: Enum.map(
            grid,
            &(String.duplicate(&1, 75))
          ) ++ [
            String.duplicate("x", 2500),
            String.duplicate("x", 2500)
          ]
end