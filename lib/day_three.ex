defmodule D3 do

  def a() do
    Read_File_Utils.read_file("three.txt")
    |> traverse(
         {0, 0},
         &(step_right(&1)
           |> step_right()
           |> step_right()
           |> step_down())
       )
  end

  def b() do
    grid = Read_File_Utils.read_file("three.txt")
    #Right 1, down 1.
    slope1 = grid
             |> traverse(
                  {0, 0},
                  &(step_right(&1)
                    |> step_down()
                    )
                )

    #Right 3, down 1.
    slope2 = grid
             |> traverse(
                  {0, 0},
                  &(step_right(&1)
                    |> step_right()
                    |> step_right()
                    |> step_down())
                )

    #Right 5, down 1.
    slope3 = grid
             |> traverse(
                  {0, 0},
                  &(step_right(&1)
                    |> step_right()
                    |> step_right()
                    |> step_right()
                    |> step_right()
                    |> step_down())
                )

    #Right 7, down 1.
    slope4 = grid
             |> traverse(
                  {0, 0},
                  &(step_right(&1)
                    |> step_right()
                    |> step_right()
                    |> step_right()
                    |> step_right()
                    |> step_right()
                    |> step_right()
                    |> step_down())
                )

    #Right 1, down 2.
    slope5 = grid
             |> traverse(
                  {0, 0},
                  &(step_right(&1)
                    |> step_down()
                    |> step_down())
                )
    slope1 * slope2 * slope3 * slope4 * slope5
  end

  def traverse(grid, current_position, traverse_instructions, tree_count \\ 0) do
    if(last_row?(grid, current_position)) do
      tree_count
    else
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

  def last_row?(grid, c), do: elem(c, 1) + 1 == Enum.count(grid)

  def step_right(c), do: put_elem(c, 0, elem(c, 0) + 1)

  def step_down(c), do: put_elem(c, 1, elem(c, 1) + 1)

  def coordinate_contain_tree(grid, c), do: coordinate_value(grid, c) === "#"

  def coordinate_value(grid, c) do
    row = Enum.at(grid, elem(c, 1))
    # divide the x positon with the total length om the string and take the remaining part instead of copying the row lots of times.
    String.at(row, rem(elem(c, 0), String.length(row)))
  end

end