defmodule D8 do

  def a() do
    Read_File_Utils.read_file("eight.txt")
    |> Enum.map(&(parse_op_info(&1)))
    |> run_instruction()
  end

  def run_instruction(boot_info, op_idx \\ 0, visited_idx_list \\ [], acc \\ 0) do
    if(op_idx in visited_idx_list) do
      acc
    else
      case Enum.at(boot_info, op_idx) |> IO.inspect do
        {"nop", _, _} ->
          run_instruction(boot_info, op_idx + 1, visited_idx_list ++ [op_idx], acc)
        {"acc", "+", number} ->
          run_instruction(
            boot_info,
            op_idx + 1,
            visited_idx_list ++ [op_idx],
            acc + String.to_integer(number)
          )
        {"acc", "-", number} ->
          run_instruction(
            boot_info,
            op_idx + 1,
            visited_idx_list ++ [op_idx],
            acc - String.to_integer(number)
          )
        {"jmp", "+", number} ->
          run_instruction(boot_info, op_idx + String.to_integer(number), visited_idx_list ++ [op_idx], acc)
        {"jmp", "-", number} ->
          run_instruction(boot_info, op_idx - String.to_integer(number), visited_idx_list ++ [op_idx], acc)
      end
    end
  end

  def plus_or_minus(number1, number2, char) do
    case char do
      "+" -> number1 + number2
      "-" -> number1 - number2
    end
  end


  def parse_op_info(input) do
    [_, op, f, number] = Regex.run(~r/([a-z]{3})\s([+-]{1})([\d]+)/, input)
    {op, f, number}
  end

end
