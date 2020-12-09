defmodule D9 do

  def a() do
    Read_File_Utils.read_file("nine.txt")
    |> Enum.map(&(String.to_integer(&1)))
    |> find_number_with_no_combination(25)
  end

  def find_number_with_no_combination(numbers, step) do
    try do
      for {_, idx} <- Enum.with_index(numbers) do
        searched_sum = Enum.at(numbers, idx + step)
                       |> IO.inspect(label: "searched_sum")
        IO.puts("first: #{idx} last #{idx + step}\n")
        IO.puts("slice #{idx} .. #{idx + step} \n")

        for {t, t_idx} <- Enum.with_index(Enum.slice(numbers, idx..idx + step)),
            {t1, t1_idx} <- Enum.with_index(Enum.slice(numbers, idx..idx + step)),
            t_idx != t1_idx and t + t1 == searched_sum
          do
          IO.puts("#{t} + #{t1} == #{searched_sum}")
          true
        end

        if(!Enum.any?(result, &(&1 == true))) do
          IO.puts("yyy number: #{searched_sum} has no numbers summing up")
          throw(searched_sum)
        end
      end

    catch
      number -> IO.puts("xxx #{number}")
    end
  end

  def find_range_summing_to_number(numbers, step, target_number) do
    for x <- Enum.with_index(numbers),

  end


end