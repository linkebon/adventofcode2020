defmodule Read_File_Utils do
  @moduledoc false

  def read_file(file) do
    file
    |> File.read!()
    |> String.split(~r{(\n)+})
  end

  def map_list_to_int(list), do: Enum.map(list, &String.to_integer/1)

end
