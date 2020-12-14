defmodule D12 do
  @east "E"
  @west "W"
  @south "S"
  @north "N"
  @left "L"
  @forward "F"
  @right "R"

  def a() do
    final_position = Read_File_Utils.read_file("twelve.txt")
                     |> Enum.map(&parse_instruction/1)
                     |> IO.inspect(label: "instructions")
                     |> Enum.reduce(
                          {
                            %{@west => 0, @east => 0, @south => 0, @north => 0},
                            @east
                          },
                          fn instruction, position ->
                            calc_position(instruction, elem(position, 0), elem(position, 1))
                          end
                        )
    manhattan_distance(elem(final_position, 0))
  end

  def calc_position(instruction, position, direction \\ @east) do
    case instruction do
      {@left, degrees} ->
        IO.puts("Current direction: #{direction} Steering #{@left}:#{degrees}")
        direction = calc_new_direction(instruction, direction)
        IO.puts("New direction #{direction}")
        {position, direction}

      {@right, degrees} ->
        IO.puts("Current direction: #{direction} Steering #{@right}:#{degrees}")
        direction = calc_new_direction(instruction, direction)
        IO.puts("New direction #{direction}")
        {position, direction}

      {dir, degrees} ->
        IO.inspect(dir, label: "dir")
        IO.inspect(degrees, label: "degrees")

        dir = case dir do
          @forward -> direction
          d -> d
        end

        IO.inspect(dir, label: "dir")

        opposite_dir = cond do
          dir == @forward -> calc_opposite_direction(direction)
          true -> calc_opposite_direction(dir)
        end

        current_degrees_in_dir = Map.get(position, dir)
        IO.inspect(current_degrees_in_dir, label: "current_degrees_in_dir")

        current_degrees_opposite_dir = Map.get(position, opposite_dir)
        IO.inspect(current_degrees_opposite_dir, label: "current_degrees_opposite_dir")

        new_degrees_in_dir = current_degrees_in_dir + degrees - current_degrees_opposite_dir
        IO.inspect(new_degrees_in_dir, label: "new_degrees_in_dir")

        new_degrees_in_opposite_dir = cond do
          current_degrees_opposite_dir - new_degrees_in_dir < 0 -> 0
          true -> current_degrees_opposite_dir - new_degrees_in_dir
        end

        IO.inspect(new_degrees_in_opposite_dir, label: "new_degrees_in_opposite_dir")

        position = Map.put(position, dir, new_degrees_in_dir)
                   |> Map.put(opposite_dir, new_degrees_in_opposite_dir)
        {position, direction}
        |> IO.inspect(label: "new position")
      _ ->
        throw("error no matching")
    end

  end

  def calc_new_direction(instruction, direction) do
    case instruction do
      {@right, degrees} when degrees == 270 and direction == @north -> @west
      {@right, degrees} when degrees == 270 and direction == @east -> @north
      {@right, degrees} when degrees == 270 and direction == @south -> @east
      {@right, degrees} when degrees == 270 and direction == @west -> @south

      {@right, degrees} when degrees == 180 and direction == @north -> @south
      {@right, degrees} when degrees == 180 and direction == @east -> @west
      {@right, degrees} when degrees == 180 and direction == @south -> @north
      {@right, degrees} when degrees == 180 and direction == @west -> @east

      {@right, degrees} when degrees == 90 and direction == @north -> @west
      {@right, degrees} when degrees == 90 and direction == @east -> @south
      {@right, degrees} when degrees == 90 and direction == @south -> @west
      {@right, degrees} when degrees == 90 and direction == @west -> @north

      {@left, degrees} when degrees == 270 and direction == @north -> @east
      {@left, degrees} when degrees == 270 and direction == @east -> @south
      {@left, degrees} when degrees == 270 and direction == @south -> @west
      {@left, degrees} when degrees == 270 and direction == @west -> @north

      {@left, degrees} when degrees == 180 and direction == @north -> @south
      {@left, degrees} when degrees == 180 and direction == @east -> @west
      {@left, degrees} when degrees == 180 and direction == @south -> @north
      {@left, degrees} when degrees == 180 and direction == @west -> @east

      {@left, degrees} when degrees == 90 and direction == @north -> @west
      {@left, degrees} when degrees == 90 and direction == @east -> @north
      {@left, degrees} when degrees == 90 and direction == @south -> @east
      {@left, degrees} when degrees == 90 and direction == @west -> @south
      _ -> throw("error")
    end

  end

  def calc_opposite_direction(direction) do
    case direction do
      @north -> @south
      @south -> @north
      @west -> @east
      @east -> @west
    end
  end

  def manhattan_distance(position) do
    abs(Map.get(position, @west) - Map.get(position, @east)) + abs(
      Map.get(position, @north) - Map.get(position, @south)
    )
  end

  def parse_instruction(instruction) do
    [_, direction, number_str] = Regex.run(~r/^([A-Z]{1})([\d]+)$/, instruction)
    {direction, String.to_integer(number_str)}
  end

  def direction(instruction), do: elem(instruction, 0)

  def units(instruction), do: elem(instruction, 1)
end


