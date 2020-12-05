defmodule D5 do

  def a() do
    # 1. calculate row and column value for each boarding pass
    # 2. zip columns and rows to new [{row, col}] structure
    # 3. calculate seat id

    rows = Read_File_Utils.read_file("five.txt")
           |> Enum.map(fn boarding_pass -> reduce_boarding_pass(boarding_pass, 0..6, 0..127) end)

    cols = Read_File_Utils.read_file("five.txt")
           |> Enum.map(fn boarding_pass -> reduce_boarding_pass(boarding_pass, 7..9, 0..7) end)

    Enum.zip(rows, cols)
    |> Enum.map(&(elem(&1, 0) * 8 + elem(&1, 1)))
    |> Enum.max()
  end

  def b() do
    rows = Read_File_Utils.read_file("five.txt")
           |> Enum.map(fn boarding_pass -> reduce_boarding_pass(boarding_pass, 0..6, 0..127) end)

    cols = Read_File_Utils.read_file("five.txt")
           |> Enum.map(fn boarding_pass -> reduce_boarding_pass(boarding_pass, 7..9, 0..7) end)

    seat_ids = Enum.zip(rows, cols)
                      |> Enum.map(&(elem(&1, 0) * 8 + elem(&1, 1)))
    case for id <- Enum.min(seat_ids)..Enum.max(seat_ids), !(id in seat_ids), do: id do
      [hd | []] -> hd
      [] -> throw("no seat id found")
    end
  end

  def reduce_boarding_pass(bp, letters_range, seat_range) do
    _..val = bp
             |> String.slice(letters_range)
             |> String.graphemes()
             |> Enum.reduce(
                  seat_range,
                  fn letter, first..last ->
                    case letter do
                      l when l == "F" or l == "L" ->
                        lower_half(first..last)
                      l when l == "R" or l == "B" ->
                        upper_half(first..last)
                    end
                  end
                )
    val
  end

  def decide_col(bp, first..last \\ 0..127) do
    nil
  end

  def lower_half(first..last) do
    middle = first..last
             |> Enum.count()
             |> div(2)
    first..last - middle
  end

  def upper_half(first..last) do
    middle = first..last
             |> Enum.count()
             |> div(2)
    middle + first..last
  end
end
