defmodule D15 do

  def a() do
    input = [18, 11, 9, 0, 5, 1]
    numbers_map = Enum.reduce(
                    Enum.with_index(input),
                    %{},
                    fn {x, idx}, map ->
                      update_numbers_spoken(x, idx + 1, map)
                    end
                  )
                  |> IO.inspect()

    turn = Enum.count(input) + 1

    elem(Enum.reduce(
      turn..2020,
      {List.last(input), numbers_map},
      fn turn, {previous_number, numbers_map} ->
        calc_next_number(previous_number, turn, numbers_map)
      end
    ), 0)
  end

  def b() do
    input = [18, 11, 9, 0, 5, 1]
    numbers_map = Enum.reduce(
                    Enum.with_index(input),
                    %{},
                    fn {x, idx}, map ->
                      update_numbers_spoken(x, idx + 1, map)
                    end
                  )
                  |> IO.inspect()

    turn = Enum.count(input) + 1

    elem(Enum.reduce(
      turn..30000000,
      {List.last(input), numbers_map},
      fn turn, {previous_number, numbers_map} ->
        calc_next_number(previous_number, turn, numbers_map)
      end
    ), 0)
  end

  def calc_next_number(previous_number, turn, numbers_map) do
    {last, last2} = Map.get(numbers_map, previous_number)
    number = if(is_nil(last2)) do
      0
    else
      last - last2
    end
    numbers_map = update_numbers_spoken(number, turn, numbers_map)
    {number, numbers_map}
  end


  def update_numbers_spoken(number, turn, numbers_map) do
    case Map.has_key?(numbers_map, number) do
      false -> Map.put(numbers_map, number, {turn, nil})
      true -> {last, before_last} = Map.get(numbers_map, number)
              Map.put(numbers_map, number, {turn, last})
    end
  end
end