defmodule DayTwo do

  def a() do
    Read_File_Utils.read_file("two.txt")
    |> Enum.map(&(String.split(&1, " ")))
    |> IO.inspect()
    |> Enum.filter(&(password_following_policy?(&1)))
    |> IO.inspect()
    |> Enum.count()
  end

  def password_following_policy?(password_info) do
    policy_letter_count = password(password_info)
                          |> String.graphemes()
                          |> Enum.count(&(&1 == letter_policy(password_info)))

    policy_letter_count >= min_occurrence(password_info) && policy_letter_count <= max_occurrence(password_info)
  end

  def min_occurrence(password_info), do:
    Enum.at(password_info, 0)
    |> String.split("-")
    |> Enum.at(0)
    |> String.to_integer()

  def max_occurrence(password_info), do:
    Enum.at(password_info, 0)
    |> String.split("-")
    |> Enum.at(1)
    |> String.to_integer()

  def letter_policy(password_info), do:
    Enum.at(password_info, 1)
    |> String.at(0)

  def password(password_info), do: Enum.at(password_info, 2)

end
