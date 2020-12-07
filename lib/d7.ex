defmodule D7 do

  def a() do
    bag_rules = Read_File_Utils.read_file("seven.txt")
                |> create_bag_rule_structure()
                |> Map.delete(:shiny_gold)
    for {curr, bag_type_rules} <- bag_rules do
      if(Enum.empty?(bag_type_rules)) do
        #IO.puts("empty")
        0
      else
        contains = for bag_rule <- bag_type_rules do
                     if(elem(bag_rule, 1) == :shiny_gold) do
                       IO.puts("directly: #{Atom.to_string(curr)}")
                       1
                     else
                       find_packing_options_for_bag_type(
                         bag_rules,
                         :shiny_gold,
                         "#{Atom.to_string(curr)}:#{Atom.to_string(elem(bag_rule, 1))}",
                         elem(bag_rule, 1)
                       )
                     end
                   end
                   |> List.flatten()
                   |> Enum.any?(&(&1))
        if(contains) do
          1
        else
          0
        end
      end
    end
    |> Enum.sum()
  end

  #%{
  #  bright_white: [{1, :shiny_gold}],
  #  dark_olive: [{3, :faded_blue}, {4, :dotted_black}],
  #  dark_orange: [{3, :bright_white}, {4, :muted_yellow}],
  #  dotted_black: [],
  #  faded_blue: [],
  #  light_red: [{1, :bright_white}, {2, :muted_yellow}],
  #  muted_yellow: [{2, :shiny_gold}, {9, :faded_blue}],
  #  vibrant_plum: [{5, :faded_blue}, {6, :dotted_black}]
  #}

  def find_packing_options_for_bag_type(bag_rules_map, bag_type_searched, path, current_bag_type) do
    bag_rules = Map.get(bag_rules_map, current_bag_type)
    if(bag_rules == nil) do
      #IO.puts("no key found for #{Atom.to_string(current_bag_type)} returning 0")
      false
    else
      if(Enum.empty?(bag_rules)) do
        #IO.puts("0 - #{path}")
        false
      else
        for rule <- bag_rules do
          if(bag_type_searched == elem(rule, 1)) do
            IO.puts("1 - #{path}")
            true
          else
            find_packing_options_for_bag_type(
              remove_current_rule(bag_rules_map, current_bag_type),
              bag_type_searched,
              "#{path}:#{Atom.to_string(elem(rule, 1))}",
              elem(rule, 1)
            )
          end
        end
      end
    end
  end

  def remove_current_rule(bag_rules, current), do: Map.delete(bag_rules, current)

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
