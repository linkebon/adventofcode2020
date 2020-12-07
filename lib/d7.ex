defmodule D7 do

  def a() do
    #light red bags contain 1 bright white bag, 2 muted yellow bags.
    Read_File_Utils.read_file("seven.txt")
    |> create_bag_rule_structure()
    |> IO.inspect(label: "bag structure")
    |> Map.delete(:shiny_gold)
    |> find_packing_options_for_bag_type(:shiny_gold)
    |> IO.inspect()
  end

  def find_packing_options_for_bag_type(bag_rules, bag_type_searched, current_bag_type \\ :first) do

    #1. sök bland keys efter bag typ
    #2. om finns, för varje rule sök gör sök 1 men ta bort den du precis sökte efter
    case current_bag_type do
      :first ->
        for {_, bag_type_rules} <- bag_rules do
          if(Enum.count(bag_type_rules) == 0) do
            0
          else
            for bag_rule <- bag_type_rules do
              if(bag_type_searched == elem(bag_rule, 1)) do
                IO.inspect(bag_rule, label: "returning 1 for")
                1
              else
                find_packing_options_for_bag_type(bag_rules, bag_type_searched, elem(bag_rule, 1))
              end
            end
          end
        end
      _ ->
        if(Map.get(bag_rules, current_bag_type) == nil) do
          IO.puts("no key found for #{Atom.to_string(current_bag_type)}")
          0
        else
          for bag_rule <- Map.get(bag_rules, current_bag_type) do
            if(bag_type_searched == elem(bag_rule, 1)) do
              IO.inspect(bag_rule, label: "returning 1 for")
              1
            else
              find_packing_options_for_bag_type(
                Map.delete(bag_rules, bag_rule),
                bag_type_searched,
                elem(bag_rule, 1)
              )
            end
          end
        end
    end
  end

  def remove_searched_bag_type_from_rules(bag_rules, bag_type_searched) do
    Map.take(bag_rules, Enum.filter(Map.keys(bag_rules), &(&1 != bag_type_searched)))
  end

  def create_bag_rule_structure(bag_rules) do
    for(bag_rule <- bag_rules, into: %{}) do
      bag_atom = parse_bag_type(bag_rule)
      bag_contains = parse_bag_contains(bag_rule)
      {bag_atom, bag_contains}
    end
  end

  def parse_bag_type(bag_type_rule) do
    [_, type, color] = Regex.run(~r/^([A-z]+)\s([A-z]+)/, bag_type_rule)
    as_atom(type, color)
  end

  def parse_bag_contains(rules) do
    rules
    |> String.split("contain")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.filter(&bag_rule_contains_bag?/1)
    |> Enum.map(
         fn rule ->
           rule = String.trim_leading(rule)
           bag_count = String.to_integer(String.at(rule, 0))
           bag_type = parse_bag_type(String.slice(rule, 2..-1))
           {bag_count, bag_type}
         end
       )
  end

  def bag_rule_contains_bag?(bag_rule), do: !String.starts_with?(String.trim_leading(bag_rule), "no")

  def as_atom(type, color), do: :"#{type}_#{color}"
end
