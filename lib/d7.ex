defmodule D7 do

  def a() do
    #light red bags contain 1 bright white bag, 2 muted yellow bags.
    Read_File_Utils.read_file("seven.txt")
    |> create_bag_rule_structure()
    |> IO.inspect(label: "bag structure")
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
    #light red bags contain 1 bright white bag, 2 muted yellow bags.
    #[_ | contain_rules] = Enum.at(String.split(rules, "contain "))

    #String.split(Enum.at(String.split(rules, "contain"), 1), ",")
    rules
    |> String.split("contain")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(
         fn rule ->
           rule = String.trim_leading(rule)
           bag_count = String.to_integer(String.at(rule, 0))
           bag_type = parse_bag_type(String.slice(rule, 2..-1))
           {bag_count, bag_type}
         end
       )
    |> IO.inspect(label: "contains")
  end

  def as_atom(type, color), do: :"#{type}_#{color}"

  def parse_bag_rule(rule) do

  end
end
