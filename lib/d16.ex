defmodule D16 do

  def a() do
    input_by_empty_line = Read_File_Utils.read_file("16.txt", ~r/\n\n/)
    rules = parse_valid_field_ranges(List.first(input_by_empty_line))
    parse_invalid_ticket_values(List.last(input_by_empty_line), rules)
    |> Enum.sum()
  end

  def parse_invalid_ticket_values(input, valid_ranges) do
    [_ | tickets] = String.split(List.last(String.split(input, ":")), "\n")
    IO.inspect(tickets)

    tickets_int = tickets
                  |> Enum.map(
                       fn ticket ->
                         String.split(ticket, ",")
                         |> Enum.map(&String.to_integer/1)
                       end
                     )
    #|> IO.inspect(label: "int")

    for ticket <- tickets_int do
      Enum.filter(
        ticket,
        fn number ->
          number_exists_in_range? = Enum.any?(
            valid_ranges,
            fn range ->
              #IO.inspect(range, label: "range")
              #IO.inspect(number, label: "number")
              (number in range)
              #|> IO.inspect(label: "in range")
            end
          )
          !number_exists_in_range?
          #|> IO.inspect(label: "filter number")
        end
      )
    end
    |> List.flatten()
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
    #|> IO.inspect(label: "valid ranges")

  end
end
