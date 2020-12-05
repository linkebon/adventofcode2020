defmodule D5 do

  def a() do
    bp = Read_File_Utils.read_file("five.txt")
    rows = Enum.map(bp, &decide_row/1)

    #cols = Enum.map(bp, &decide_col/1)
    #      |> IO.inspect(label: "col")


    #row_letters(Enum.at(bp, 0))
    #|> IO.inspect(label: "row")
    #col_letters(Enum.at(bp, 0))
    #|> IO.inspect(label: "col")

  end

  # 1. mappa om till row value och col value
  # 2. zippa col och row
  # 3. beräkna row * 8 + col

  def decide_row(bp, first..last \\ 0..127) do
    bp
    |> row_letters()
    |> String.graphemes()
    |> IO.inspect(label: "letters")
    |> Enum.reduce(
         0..127,
         fn letter, first..last ->
           case letter do
             "F" -> lower_half(first..last)
             "B" -> upper_half(first..last)
           end
         end
       )
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

  def row_letters(bp), do: String.slice(bp, 0..6)

  def col_letters(bp), do: String.slice(bp, 7..9)








end
