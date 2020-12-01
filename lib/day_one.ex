defmodule DayOne do

  def a() do
    list = Read_File_Utils.read_file("one.txt")
           |> Read_File_Utils.map_list_to_int()

    for x <- list, y <- list, x + y == 2020, do: IO.puts("x*y=#{x*y}")
  end

  def b() do
    list = Read_File_Utils.read_file("one.txt")
           |> Read_File_Utils.map_list_to_int()

    for x <- list, y <- list, z <- list, x + y + z == 2020, do: IO.puts("x*y*z=#{x*y*z}")
  end

end


