defmodule D4 do
  @mandatory ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @optional ["cid"]

  def a() do
    Read_File_Utils.read_file("four.txt", ~r{\n\n})
    |> Enum.map(&(String.replace(&1, "\n", " ")))
    |> Enum.map(&structure_passport_input/1)
    |> Enum.filter(&a_valid_passport?/1)
    |> Enum.count()
  end

  def b() do
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

  def valid_passport?(passport) do
    Enum.all?(
      @mandatory,
      fn man_attr ->
        man_attrs_exist = man_attr in List.flatten(passport)
        if(man_attrs_exist) do
          found_attr = Enum.find(passport, &(Enum.at(&1, 0) == man_attr))
          attr_valid = case found_attr do
            ["byr", val] -> birth_year?(val)
            ["iyr", val] -> issue_year?(val)
            ["eyr", val] -> expiration_year?(val)
            ["hgt", val] -> height?(val)
            ["hcl", val] -> hair_color?(val)
            ["ecl", val] -> eye_color?(val)
            ["pid", val] -> passport_id?(val)
          end
        else
          false
        end
      end
    )
  end

  def birth_year?(year) do
    parsed = String.to_integer(year)
    (parsed >= 1920 and parsed <= 2002)
  end

  def issue_year?(year) do
    parsed = String.to_integer(year)
    (parsed >= 2010 and parsed <= 2020)
  end

  def expiration_year?(year) do
    parsed = String.to_integer(year)
    (parsed >= 2020 and parsed <= 2030)
  end

  def height?(height) do
    if(String.contains?(height, "cm")) do
      parsed_height = String.to_integer(String.replace(height, "cm", ""))
      parsed_height >= 150 and parsed_height <= 193
    else
      parsed_height = String.to_integer(String.replace(height, "in", ""))
      parsed_height >= 59 and parsed_height <= 76
    end
  end

  def hair_color?(color) do
    String.match?(color, ~r/^#[0-9a-f]{6}$/)
  end

  def eye_color?(color),
      do: color in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  def passport_id?(id) do
    String.match?(id, ~r/^[\d]{9}$/)
  end

  def a_valid_passport?(passport) do
    Enum.all?(
      @mandatory,
      fn man_attr ->
        man_attrs_exist = man_attr in List.flatten(passport)
      end
    )
  end

end
