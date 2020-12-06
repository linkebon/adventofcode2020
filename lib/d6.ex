defmodule D6 do

  def a() do
    Read_File_Utils.read_file("six.txt", ~r/\n\n/)
    |> Enum.map(&(Enum.count(Enum.uniq(String.graphemes(String.replace(&1, "\n", ""))))))
    |> Enum.sum()
  end

  def b() do
    all_group_answers = Read_File_Utils.read_file("six.txt", ~r/\n\n/)
                        |> Enum.map(&(String.split(&1, "\n")))
    for(group_answer <- all_group_answers) do
      person_with_most_answers = Enum.max_by(group_answer, &(String.length(&1)))
                                 |> String.graphemes()
      Enum.reduce(
        person_with_most_answers,
        0,
        fn current_answer, acc ->
          if(all_person_in_group_answer_same?(group_answer, current_answer)) do
            acc + 1
          else
            acc
          end
        end
      )
    end
    |> Enum.sum()
  end

  def all_person_in_group_answer_same?(group_answer, answer),
      do: Enum.all?(group_answer, &(String.contains?(&1, answer)))

  def most_answers_in_group(group) do
    Enum.max_by(group, &(String.length(&1)))
  end

end
