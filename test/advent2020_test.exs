defmodule Advent2020Test do
  use ExUnit.Case
  doctest Advent2020

  test "Day 1 A" do
    assert DayOne.a() == 388075
  end

  test "Day 1 B" do
    assert DayOne.b() == 293450526
  end
end
