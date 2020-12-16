defmodule D16 do

  def a() do
    input_by_empty_line = Read_File_Utils.read_file("16.txt", ~r/\n\n/)
    rules = parse_valid_field_ranges(List.first(input_by_empty_line))
    parse_valid_tickets(List.last(input_by_empty_line), rules)
    |> Enum.count()
  end

  def parse_valid_tickets(input, valid_ranges) do
    [_ | tickets] = String.split(List.last(String.split(input, ":")), "\n")
    IO.inspect(tickets)
    Enum.filter(
      tickets,
      fn ticket ->
        numbers = String.split(ticket, ",")
                  |> Enum.map(&String.to_integer/1)
        !Enum.all?(
          numbers,
          fn number ->
            Enum.any?(
              valid_ranges,
              fn range ->
                IO.inspect(range, label: "range")
                IO.inspect(number, label: "number")
                (number in range)
                |> IO.inspect(label: "in range")
              end
            )
          end
        )
      end
    )
    |> IO.inspect(label: "filtered")

  end

  def parse_valid_field_ranges(input) do
    rules_splitted = String.split(input, "\n")
    Enum.map(
      rules_splitted,
      fn r ->
        [_, r1, r2, r3, r4] = Regex.run(~r/:\s([\d]+)-([\d]+)\sor\s([\d]+)-([\d]+)/, r)
        [String.to_integer(r1)..String.to_integer(r2), String.to_integer(r3)..String.to_integer(r4)]
      end
    )
    |> List.flatten()
    |> IO.inspect(label: "valid ranges")

  end
end
