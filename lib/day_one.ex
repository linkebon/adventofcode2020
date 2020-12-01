defmodule DayOne do

  def a() do
    list = Read_File_Utils.read_file("one.txt")
           |> Read_File_Utils.map_list_to_int()
    try do
      for x <- list, y <- list, x + y == 2020, do: throw(x * y)
    catch
      solution -> IO.puts("Solution: #{solution}")
    end
  end

  def b() do
    list = Read_File_Utils.read_file("one.txt")
           |> Read_File_Utils.map_list_to_int()
    try do
      for x <- list, y <- list, z <- list, x + y + z == 2020, do: throw(x * y * z)
    catch
      solution -> IO.puts("Solution: #{solution}")
    end
  end
end

