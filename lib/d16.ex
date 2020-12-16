defmodule D16 do

  def a() do
    input_by_empty_line = Read_File_Utils.read_file("16.txt", ~r/\n\n/)
    rules = parse_valid_field_ranges_a(List.first(input_by_empty_line))
    parse_invalid_ticket_values(List.last(input_by_empty_line), rules)
    |> Enum.sum()
  end

  def b() do
    input_by_empty_line = Read_File_Utils.read_file("16.txt", ~r/\n\n/)
    rules = parse_valid_field_ranges(List.first(input_by_empty_line))
    valid_tickets = valid_tickets(List.last(input_by_empty_line), rules)
    find_possible_rule_matching_field_index(valid_tickets, rules)

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


  def find_possible_rule_matching_field_index(tickets, valid_ranges) do
    tickets = [[3, 9, 18], [15, 1, 5], [5, 14, 9]]

    map = %{}
    for(ticket <- tickets, {ticket_number, idx} <- Enum.with_index(ticket), into: map) do
      valid_ranges_for_number = Enum.filter(valid_ranges, &ticket_number in &1)
                                |> IO.inspect(label: "valid ranges for ticket: #{ticket_number}")
      map_set = case Map.get(map, idx) do
        nil -> MapSet.new()
        set -> set
      end

      map_set = Enum.reduce(valid_ranges_for_number, map_set, &MapSet.put(&2, &1))

      {idx, map_set}
    end

  end

  def valid_tickets(input, valid_ranges) do
    [_ | tickets] = String.split(List.last(String.split(input, ":")), "\n")

    tickets_int = tickets
                  |> Enum.map(
                       fn ticket ->
                         String.split(ticket, ",")
                         |> Enum.map(&String.to_integer/1)
                       end
                     )
                  |> IO.inspect()

    for(ticket <- tickets_int) do
      Enum.filter(
        ticket,
        fn ticket_value ->
          Enum.any?(
            valid_ranges,
            &(ticket_value in &1)
          )
        end
      )
    end
    |> Enum.filter(&!Enum.empty?(&1))

  end

  def parse_valid_field_ranges(input) do
    rules_splitted = String.split(input, "\n")
    Enum.map(
      rules_splitted,
      fn r ->
        [_, name, r1, r2, r3, r4] = Regex.run(~r/([A-z]+):\s([\d]+)-([\d]+)\sor\s([\d]+)-([\d]+)/, r)
        [name, String.to_integer(r1)..String.to_integer(r2), String.to_integer(r3)..String.to_integer(r4)]
      end
    )
    #|> List.flatten()
    #|> IO.inspect(label: "valid ranges")

  end

  def parse_valid_field_ranges_a(input) do
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
