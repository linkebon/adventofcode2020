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

  test "Day 4 A" do
    assert D4.a() == 222
  end

  test "Day 4 B" do
    assert D4.b() == 140
  end

  test "Day 5 A" do
    assert D5.a() == 947
  end

  test "Day 5 B" do
    assert D5.b() == 636
  end

  test "Day 6 A" do
    assert D6.a() == 6310
  end

end
