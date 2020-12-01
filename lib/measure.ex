defmodule Measure do
  def measure_time_ms(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1000)
  end
end