defmodule D10 do

  def a() do
    jolt_diff_tuple = Read_File_Utils.map_list_to_int(Read_File_Utils.read_file("ten.txt"))
                      |> Enum.sort()
                      |> add_charging_outlet_jolt()
                      |> add_device_jolt()
                      |> count_differences_of_jolts()

    elem(jolt_diff_tuple, 0) * elem(jolt_diff_tuple, 1)
  end

  def add_charging_outlet_jolt(adapters), do: [0] ++ adapters

  def add_device_jolt(adapters), do: adapters ++ [List.last(adapters) + 3]

  def count_differences_of_jolts(adapters) do
    adapters = Enum.chunk_every(adapters, 2, 1, :discard)
               |> IO.inspect(label: "adapters")
    Enum.reduce(
      adapters,
      {0, 0},
      fn [adapter1, adapter2], jolt_acc ->
        case calc_jolt_difference(adapter1, adapter2) do
          1 ->
            put_elem(jolt_acc, 0, elem(jolt_acc, 0) + 1)
            |> IO.inspect(label: "increasing 1")
          3 ->
            put_elem(jolt_acc, 1, elem(jolt_acc, 1) + 1)
            |> IO.inspect(label: "increasing 3")
          _ ->
            jolt_acc
        end
      end
    )
    |> IO.inspect(label: "jolt difference tuple")
  end

  def calc_jolt_difference(a1, a2) do
    IO.inspect(a1, label: "a1")
    IO.inspect(a2, label: "a2")
    (a2 - a1)
    |> IO.inspect(label: "diff jolt")
  end

end
