defmodule Advent2020Test do
  use ExUnit.Case
  doctest Advent2020

  test "Day 1 A" do
    assert DayOne.a() == 388075
  end

  test "Day 1 B" do
    assert DayOne.b() == 293450526
  end

  test "Day 2 A" do
    assert DayTwo.a() == 542
  end

  test "Day 2 B" do
    assert DayTwo.b() == 360
  end

  test "Day 3 A" do
    assert D3.a() == 270
  end

  test "Day 3 B" do
    assert D3.b() == 2122848000
  end
end
