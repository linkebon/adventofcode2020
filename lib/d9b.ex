defmodule D9B do

  def b() do
    numbers = Read_File_Utils.read_file("nine.txt")
              |> Enum.map(&(String.to_integer(&1)))
    # find number which has no number summing up to it in ranges of 25
    target_number = find_number_with_no_combination(numbers, 25)
    #find any contiguous range summing up to previous number and sum smallest and largest number in that range
    find_number_combination(numbers, target_number)
  end

  def find_number_combination(numbers, target_number) do
    try do
      Enum.each(
        Enum.with_index(numbers),
        fn {_, idx} ->
          case sum_range(Enum.slice(numbers, idx..Enum.count(numbers) - 1), 0, target_number) do
            {true, number} -> throw(number)
            _ ->
          end
        end
      )
    catch
      solution -> solution
    end
  end

  def sum_range(number_range, acc, target_number, visited \\ []) do
    case number_range do
      [] ->
        {false, 0}
      _ ->
        current = Enum.at(number_range, 0)
        if(acc + current == target_number) do
          visited = visited ++ [current]
          sorted = Enum.sort(visited)
          {true, List.first(sorted) + List.last(sorted)}
        else
          [_ | tail] = number_range
          sum_range(tail, acc + current, target_number, visited ++ [current])
        end
    end


  end

  def find_number_with_no_combination(numbers, step) do
    try do
      for {_, idx} <- Enum.with_index(numbers) do
        searched_sum = Enum.at(numbers, idx + step)

        result = for {t, t_idx} <- Enum.with_index(Enum.slice(numbers, idx..idx + step)),
                     {t1, t1_idx} <- Enum.with_index(Enum.slice(numbers, idx..idx + step)),
                     t_idx != t1_idx and t + t1 == searched_sum
          do
          true
        end

        if(!Enum.any?(result, &(&1 == true))) do
          throw(searched_sum)
        end
      end
    catch
      number -> number
    end
  end

end