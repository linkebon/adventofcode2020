defmodule D11 do

  @empty "L"
  @occupied "#"
  @floor "."

  def a() do
    Read_File_Utils.read_file("eleven.txt")
    |> populate_grid()
    |> traverse()
    |> count_occupied_seats()
  end

  def traverse(grid) do
    updates = traverse_find_updates(grid)
    case updates do
      [] -> IO.inspect(grid, label: "done")
      _ ->
        traverse(
          Enum.reduce(
            updates,
            grid,
            fn update, acc -> update_coordinate(acc, elem(update, 0), elem(update, 1)) end
          )
        )
    end
  end

  def traverse_find_updates(grid, coordinate \\ {0, 0}, updates \\ []) do
    case valid_spot?(grid, coordinate) do
      false -> updates
      _ -> case matrix_value(grid, coordinate) do
             "L" -> cond do
                      find_neighbor_occupied_coordinates(grid, coordinate, 1)
                      |> Enum.all?(&matrix_value(grid, &1) == @empty or matrix_value(grid, &1) == @floor)
                      -> traverse_find_updates(grid, next_coordinate(grid, coordinate), updates ++ [{coordinate, "#"}])
                      true ->
                        traverse_find_updates(grid, next_coordinate(grid, coordinate), updates)
                    end
             "#" -> cond do
                      find_neighbor_occupied_coordinates(grid, coordinate, 1)
                      |> Enum.filter(&matrix_value(grid, &1) == @occupied)
                      |> Enum.count() >= 4
                      -> traverse_find_updates(grid, next_coordinate(grid, coordinate), updates ++ [{coordinate, "L"}])
                      true ->
                        traverse_find_updates(grid, next_coordinate(grid, coordinate), updates)
                    end
             _ -> traverse_find_updates(grid, next_coordinate(grid, coordinate), updates)
           end

    end
  end

  def next_coordinate(grid, coordinate) do
    if(elem(coordinate, 1) == Enum.count(Map.get(grid, elem(coordinate, 0))) - 1) do
      {elem(coordinate, 0) + 1, 0}
    else
      {elem(coordinate, 0), elem(coordinate, 1) + 1}
    end
  end

  def count_occupied_seats(grid, occupied_count \\ 0, coordinate \\ {0, 0}) do
    case valid_spot?(grid, coordinate) do
      false -> occupied_count
      _ ->
        occupied_count =
          if(matrix_value(grid, coordinate) == @occupied) do
            occupied_count + 1
          else
            occupied_count
          end
        count_occupied_seats(grid, occupied_count, next_coordinate(grid, coordinate))
    end
  end

  def find_neighbor_occupied_coordinates(grid, coordinate, space) do
    #grid = %{0 => ["L", ".", "L", "L", ".", "L", "L", ".", "L", "L"], 1 => ["L", "L", "L", "L", "L", "L", "L", ".", "L", "L"], 2 => ["L", ".", "L", ".", "L", ".", ".", "L", ".", "."], 3 => ["L", "L", "L", "L", "L", "L", "L", ".", "L", "L"], 4 => ["L", ".", "L", "L", ".", "L", "L", ".", "L", "L"], 5 => ["L", ".", "L", "L", "L", "L", "L", ".", "L", "L"], 6 => [".", ".", "L", ".", "L", ".", ".", ".", ".", "."], 7 => ["L", "L", "L", "L", "L", "L", "L", "L", "L", "L"], 8 => ["L", ".", "L", "L", "L", "L", "L", "L", ".", "L"], 9 => ["L", ".", "L", "L", "L", "L", "L", ".", "L", "L"]} |> IO.inspect(label: "grid")
    row_idx = elem(coordinate, 0)
    col_idx = elem(coordinate, 1)
    for x <- 1..space do
      [
        {row_idx, col_idx - x},
        {row_idx, col_idx + x},
        {row_idx + x, col_idx},
        {row_idx - x, col_idx},
        {row_idx - x, col_idx - x},
        {row_idx - x, col_idx + x},
        {row_idx + x, col_idx - x},
        {row_idx + x, col_idx + x}
      ]
    end
    |> List.flatten()
    |> Enum.filter(&valid_spot?(grid, &1))
  end

  def valid_spot?(grid, coordinate) do
    row_idx = elem(coordinate, 0)
    col_idx = elem(coordinate, 1)
    case Map.get(grid, row_idx) do
      nil -> false
      row -> col_idx >= 0 and Enum.at(row, col_idx) != nil
    end
  end

  def matrix_value(grid, coordinate), do: Enum.at(Map.get(grid, elem(coordinate, 0)), elem(coordinate, 1))

  def update_coordinate(grid, coordinate, replace_char) do
    updated_seats_row = List.replace_at(
      Map.get(grid, elem(coordinate, 0)),
      elem(coordinate, 1),
      replace_char
    )
    Map.put(grid, elem(coordinate, 0), updated_seats_row)
  end

  def populate_grid(input), do:
    for {row, idx} <- Enum.with_index(input), into: %{}, do: {idx, String.graphemes(row)}

end