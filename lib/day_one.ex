defmodule DayOne do

  def a() do
    list = Read_File_Utils.read_file("one.txt")
           |> Read_File_Utils.map_list_to_int()

    for x <- list, y <- list, x + y == 2020, do: IO.puts("x*y=#{x*y}")
  end

end


