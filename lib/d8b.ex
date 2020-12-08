defmodule D8B do

  def b() do
    Read_File_Utils.read_file("eight.txt")
    |> Enum.map(&(parse_op_info(&1)))
    |> fix_boot_instructions()
    |> run_instruction()
  end

  def fix_boot_instructions(boot_info, op_idx \\ 0) do
    case Enum.at(boot_info, op_idx) do
      {"nop", "+", number} ->
        int_number = String.to_integer(number)
        if(int_number != 0) do
          IO.puts("replacing #{op_idx} with jmp + #{number}")
          boot_fixed = boot_fixed?(List.replace_at(boot_info, op_idx, {"jmp", "+", number}))
          if(boot_fixed) do
            IO.puts("replacing idx: #{op_idx}}")
            List.replace_at(boot_info, op_idx, {"jmp", "+", number})
            |> IO.inspect(label: "replacing")
          else
            fix_boot_instructions(boot_info, op_idx + 1)
          end
        else
          fix_boot_instructions(boot_info, op_idx + 1)
        end

      {"nop", "-", number} ->
        int_number = String.to_integer(number)

        if(int_number != 0) do
          IO.puts("replacing #{op_idx} with jmp - #{number}")
          boot_fixed = boot_fixed?(List.replace_at(boot_info, op_idx, {"jmp", "-", number}))
          if(boot_fixed) do
            IO.puts("replacing idx: #{op_idx}}")
            List.replace_at(boot_info, op_idx, {"jmp", "+", number})
            |> IO.inspect(label: "replacing")
          else
            fix_boot_instructions(boot_info, op_idx + 1)
          end
        else
          fix_boot_instructions(boot_info, op_idx + 1)
        end

      {"acc", _, _} ->
        fix_boot_instructions(boot_info, op_idx + 1)

      {"jmp", "+", number} ->
        number = String.to_integer(number)
        IO.puts("replacing #{op_idx} with nop + #{number}")
        if(boot_fixed?(List.replace_at(boot_info, op_idx, {"nop", "+", number}))) do
          List.replace_at(boot_info, op_idx, {"nop", "+", number})
          |> IO.inspect(label: "replacing")
        else
          fix_boot_instructions(boot_info, op_idx + number)
        end

      {"jmp", "-", number} ->
        number = String.to_integer(number)
        IO.puts("replacing #{op_idx} with nop - #{number}")
        if(boot_fixed?(List.replace_at(boot_info, op_idx, {"nop", "-", number}))) do
          List.replace_at(boot_info, op_idx, {"nop", "-", number})
          |> IO.inspect(label: "replacing")
        else
          fix_boot_instructions(boot_info, op_idx - number)
        end
    end
  end

  def boot_fixed?(boot_info, op_idx \\ 0, visited_idx_list \\ []) do
    if(op_idx in visited_idx_list) do
      IO.puts("already visited #{op_idx}")
      false
    else
      if(last_op?(boot_info, op_idx)) do
        IO.puts("found last op_idx: #{op_idx}")
        true
      else
        case Enum.at(boot_info, op_idx) do
          {"jmp", "+", number} ->
            boot_fixed?(boot_info, op_idx + String.to_integer(number), visited_idx_list ++ [op_idx])

          {"jmp", "-", number} ->
            boot_fixed?(boot_info, op_idx - String.to_integer(number), visited_idx_list ++ [op_idx])

          _ -> boot_fixed?(
                 boot_info,
                 op_idx + 1,
                 visited_idx_list ++ [op_idx]
               )
        end
      end
    end
  end

  def run_instruction(boot_info, op_idx \\ 0, visited_idx_list \\ [], acc \\ 0, complete \\ false) do
    if(complete) do
      IO.puts("completed op_idx + #{op_idx}")
      acc
    else
      IO.puts("op_idx: #{op_idx}")
      case Enum.at(boot_info, op_idx)
           |> IO.inspect(label: "run_instruction") do
        {"nop", _, _} ->
          run_instruction(boot_info, op_idx + 1, visited_idx_list ++ [op_idx], acc, Enum.count(boot_info) - 1 == op_idx)
        {"acc", "+", number} ->
          run_instruction(
            boot_info,
            op_idx + 1,
            visited_idx_list ++ [op_idx],
            acc + String.to_integer(number),
            Enum.count(boot_info) - 1 == op_idx
          )
        {"acc", "-", number} ->
          run_instruction(
            boot_info,
            op_idx + 1,
            visited_idx_list ++ [op_idx],
            acc - String.to_integer(number),
            Enum.count(boot_info) - 1 == op_idx
          )
        {"jmp", "+", number} ->
          run_instruction(
            boot_info,
            (op_idx + String.to_integer(number)),
            visited_idx_list ++ [op_idx],
            acc,
            Enum.count(boot_info) - 1 == op_idx
          )
        {"jmp", "-", number} ->
          run_instruction(
            boot_info,
            op_idx - String.to_integer(number),
            visited_idx_list ++ [op_idx],
            acc,
            Enum.count(boot_info) - 1 == op_idx
          )
      end
    end
  end

  def last_op?(boot_info, current_idx) do
    cond do
      Enum.count(boot_info) - 1 == current_idx ->
        IO.puts "last op found: #{current_idx}"
        true
      true ->
        false
    end
  end

  def parse_op_info(input) do
    [_, op, f, number] = Regex.run(~r/([a-z]{3})\s([+-]{1})([\d]+)/, input)
    {op, f, number}
  end

end


