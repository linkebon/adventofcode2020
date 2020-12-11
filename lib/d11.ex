defmodule D11 do
  @test %{
    0 => ["L", ".", "L", "L", ".", "L", "L", ".", "L", "L"],
    1 => ["L", "L", "L", "L", "L", "L", "L", ".", "L", "L"],
    2 => ["L", ".", "L", ".", "L", ".", ".", "L", ".", "."],
    3 => ["L", "L", "L", "L", ".", "L", "L", ".", "L", "L"],
    4 => ["L", ".", "L", "L", ".", "L", "L", ".", "L", "L"],
    5 => ["L", ".", "L", "L", "L", "L", "L", ".", "L", "L"],
    6 => [".", ".", "L", ".", "L", ".", ".", ".", ".", "."],
    7 => ["L", "L", "L", "L", "L", "L", "L", "L", "L", "L"],
    8 => ["L", ".", "L", "L", "L", "L", "L", "L", ".", "L"],
    9 => ["L", ".", "L", "L", "L", "L", "L", ".", "L", "L"]
  }
  def a() do
    Read_File_Utils.read_file("eleven.txt")
    |> populate_grid()

  end

  def populate_grid(input), do:
    for {row, idx} <- Enum.with_index(input), into: %{}, do: {idx, String.graphemes(row)}

  def next_round(grid, seats_changed \\ 0) do

  end

  def find_changing_seats_positions(grid \\ @test) do
    for {row_idx, seats} <- grid, {seat, seat_idx} <- Enum.with_index(seats), into: [] do
      case seat do
        "L" -> nil
        "#" -> nil
        _ -> nil
      end
    end
  end

  def t() do
    find_neighbor_seats_by_four(0, 1)

  end

  def find_neighbor_seats_by_four(row_idx, col_idx, grid \\ @test) do
    left = {row_idx, col_idx - 4}
    right = {row_idx, col_idx + 4}
    down = {row_idx + 4, col_idx}
    up = {row_idx - 4, col_idx}
    diagonal_left_up = {row_idx - 4, col_idx - 4}
    diagonal_left_down = {row_idx - 4, col_idx + 4}
    diagonal_right_up = {row_idx + 4, col_idx - 4}
    diagonal_right_down = {row_idx + 4, col_idx + 4}
    neighbor_coordinates = [left, right, down, up, diagonal_left_up, diagonal_left_down, diagonal_right_up, diagonal_right_down]
                           |> IO.inspect(label: "neighbor not filter")
                           |> Enum.filter(&valid_spot?(grid, elem(&1, 0), elem(&1, 1)))
                           |> IO.inspect(label: "neighbor filtered")
  end

  def valid_spot?(grid, row_idx, col_idx) do
    case Map.get(grid, row_idx) do
      nil -> false
      row -> col_idx >= 0 and Enum.at(row, col_idx) != nil
    end
  end

end