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

  def b() do
    Read_File_Utils.read_file("eleven.txt")
    |> populate_grid()

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

  def find_updates_extended(grid, coordinate \\ {0, 0}, updates \\ []) do

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

  def find_neighbor_coordinates_for_closest_seat_in_each_direction(grid, coordinate, space) do
    grid = Read_File_Utils.read_file("eleven.txt")
           |> populate_grid()
    row_idx = elem(coordinate, 0)
    col_idx = elem(coordinate, 1)
    nearest_seat_map = %{
      :left => [],
      :up_left => [],
      :up => [],
      :up_right => [],
      :right => [],
      :down_right => [],
      :down => [],
      :down_left => []
    }

    nearest_seat_map = Enum.reduce(
      1..space,
      nearest_seat_map,
      fn x, map ->
        Map.put(map, :left, Map.get(map, :left) ++ [{row_idx, col_idx - x}])
        |> Map.put(:right, Map.get(map, :right) ++ [{row_idx, col_idx + x}])
        |> Map.put(:down, Map.get(map, :down) ++ [{row_idx + x, col_idx}])
        |> Map.put(:up, Map.get(map, :up) ++ [{row_idx - x, col_idx}])
        |> Map.put(:up_left, Map.get(map, :up_left) ++ [{row_idx - x, col_idx - x}])
        |> Map.put(:up_right, Map.get(map, :up_right) ++ [{row_idx - x, col_idx + x}])
        |> Map.put(:down_left, Map.get(map, :down_left) ++ [{row_idx + x, col_idx - x}])
        |> Map.put(:down_right, Map.get(map, :down_right) ++ [{row_idx + x, col_idx + x}])
      end
    )

    [find_first_seat(grid, Map.get(nearest_seat_map, :left))]
    ++ [find_first_seat(grid, Map.get(nearest_seat_map, :right))]
    ++ [find_first_seat(grid, Map.get(nearest_seat_map, :down))]
       ++ [find_first_seat(grid, Map.get(nearest_seat_map, :up))]
       ++ [find_first_seat(grid, Map.get(nearest_seat_map, :up_left))]
          ++ [find_first_seat(grid, Map.get(nearest_seat_map, :up_right))]
          ++ [find_first_seat(grid, Map.get(nearest_seat_map, :down_left))]
             ++ [find_first_seat(grid, Map.get(nearest_seat_map, :down_right))]
    |> Enum.filter(& &1 != nil)
  end

  def find_first_seat(grid, neighbor_seats) do
    case Enum.filter(neighbor_seats, &(valid_spot?(grid, &1) and is_seat?(grid, &1))) do
      [] -> nil
      [h | t] -> h
    end
  end

  def is_seat?(grid, coordinate) do
    val = matrix_value(grid, coordinate)
    val == @occupied or val == @empty
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