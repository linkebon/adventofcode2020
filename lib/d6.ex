defmodule D6 do

  def a() do
    Read_File_Utils.read_file("six.txt", ~r/\n\n/)
    |> Enum.map(&(Enum.count(Enum.uniq(String.graphemes(String.replace(&1, "\n", ""))))))
    |> Enum.sum()
  end

end
