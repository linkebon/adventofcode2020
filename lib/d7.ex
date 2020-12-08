defmodule D7 do

  def b() do
    bag_rules = Read_File_Utils.read_file("seven.txt")
                |> create_bag_rule_structure()

    count_enclosing_bags_options(
      bag_rules,
      :shiny_gold
    )
  end

  #bag_rules_map structure: %{:shiny_gold => [{3, :shiny_black},{5, muted_red}],:shiny_black => [{3, :shiny_white},{5, muted_white}]} etc
  def count_enclosing_bags_options(bag_rules_map, bag_name) do
    Enum.reduce(
      Map.get(bag_rules_map, bag_name),
      0,
      fn current_bag_tuple, acc ->
        multiplier = elem(current_bag_tuple, 0)
        next_bag_name = elem(current_bag_tuple, 1)
        if(multiplier == 0) do
          acc
        else
          acc + multiplier + (multiplier * count_enclosing_bags_options(bag_rules_map, next_bag_name))
        end
      end
    )
  end

  def a() do
    bag_rules = Read_File_Utils.read_file("seven.txt")
                |> create_bag_rule_structure()
                |> Map.delete(:shiny_gold)
    for {curr, bag_type_rules} <- bag_rules do
      if(Enum.empty?(bag_type_rules)) do
        0
      else
        if(
          for bag_rule <- bag_type_rules do
            if(elem(bag_rule, 1) == :shiny_gold) do
              1
            else
              encloses_searched_bag_type?(
                bag_rules,
                :shiny_gold,
                "#{Atom.to_string(curr)}:#{Atom.to_string(elem(bag_rule, 1))}",
                elem(bag_rule, 1)
              )
            end
          end
          |> List.flatten()
          |> Enum.any?(&(&1))
        ) do
          1
        else
          0
        end
      end
    end
    |> Enum.sum()
  end

  def remove_current_rule(bag_rules, current), do: Map.delete(bag_rules, current)

  def create_bag_rule_structure(bag_rules) do
    for(bag_rule <- bag_rules, into: %{}) do
      bag_atom = parse_bag_type(bag_rule)
      bag_contains = parse_bag_contains_including_empty_bags(bag_rule)
      {bag_atom, bag_contains}
    end
  end

  def encloses_searched_bag_type?(bag_rules_map, bag_type_searched, path, current_bag_type) do
    bag_rules = Map.get(bag_rules_map, current_bag_type)
    if(bag_rules == nil) do
      false
    else
      if(Enum.empty?(bag_rules)) do
        false
      else
        for rule <- bag_rules do
          if(bag_type_searched == elem(rule, 1)) do
            true
          else
            encloses_searched_bag_type?(
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

  def parse_bag_contains_including_empty_bags(rules) do
    rules
    |> String.split("contain")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(
         fn rule ->
           rule = String.trim_leading(rule)
           if(String.starts_with?(rule, "no")) do
             {0, :no_bag}
           else
             bag_count = String.to_integer(String.at(rule, 0))
             bag_type = parse_bag_type(String.slice(rule, 2..-1))
             {bag_count, bag_type}
           end
         end
       )
  end

  def bag_rule_contains_bag?(bag_rule), do: !String.starts_with?(String.trim_leading(bag_rule), "no")

  def as_atom(type, color), do: :"#{type}_#{color}"
end
