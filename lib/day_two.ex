defmodule DayTwo do

  def a() do
    Read_File_Utils.read_file("two.txt")
    |> Enum.map(&(String.split(&1, " ")))
    |> Enum.filter(&(password_following_policy?(&1)))
    |> Enum.count()
  end

  def b() do
    Read_File_Utils.read_file("two.txt")
    |> Enum.map(&(String.split(&1, " ")))
    |> Enum.filter(&(password_following_policy_extended?(&1)))
    |> Enum.count()
  end

  def password_following_policy_extended?(password_info) do
    chars_as_list = password(password_info)
                    |> String.graphemes()
    letter_searched = letter_policy(password_info)
    case [Enum.at(chars_as_list, index_pos1(password_info)), Enum.at(chars_as_list, index_pos2(password_info))] do
      [first, second] when first == letter_searched and second != letter_searched -> true
      [first, second] when first != letter_searched and second == letter_searched -> true
      _ -> false
    end
  end

  def password_following_policy?(password_info) do
    policy_letter_count = password(password_info)
                          |> String.graphemes()
                          |> Enum.count(&(&1 == letter_policy(password_info)))

    policy_letter_count >= min_occurrence(password_info) && policy_letter_count <= max_occurrence(password_info)
  end

  def index_pos1(password_info), do: min_occurrence(password_info) - 1

  def index_pos2(password_info), do: max_occurrence(password_info) - 1

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
