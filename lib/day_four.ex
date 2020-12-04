defmodule D4 do
  @mandatory ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @optional ["cid"]

  def a() do
    Read_File_Utils.read_file("four.txt", ~r{\n\n})
    |> Enum.map(&(String.replace(&1, "\n", " ")))
    |> Enum.map(&structure_passport_input/1)
    |> Enum.filter(&valid_passport?/1)
    |> Enum.count()
  end

  def structure_passport_input(passport, passport_format \\ ~r/([A-z]{3}):([A-z0-9#]+)/) do
    passport
    |> String.split(~r{ })
    |> Enum.map(
         fn attr ->
           [_, key, value] = Regex.run(passport_format, attr)
           [key, value]
         end
       )
  end

  def valid_passport?(passport), do: Enum.all?(@mandatory, &(&1 in List.flatten(passport)))

end
