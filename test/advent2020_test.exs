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

  test "Day 6 B" do
    assert D6.b() == 3193
  end

  test "Day 7 A" do
    assert D7.a() == 268
  end

  test "Day 7 B" do
    assert D7.b() == 7867
  end

  test "Day 8 A" do
    assert D8.a() == 1818
  end

  test "Day 8 B" do
    assert D8B.b() == 631
  end

  test "Day 9A" do
    assert D9.a() == 32321523
  end

  test "Day 9B" do
    assert D9B.b() == 4794981
  end

  test "Day 11 A" do
    assert D11.a() == 2468
  end

  #to slow test :) 5 min
  #test "Day 11 B" do
   # assert D12.b() == 2214
  #end

  test "Day 12 A" do
    assert D12.a() == 1032
  end

  #test "D15 a" do
  #  assert D15.a() == 959
  #end


  #test "D15 b" do
  #  assert D15.b() == 116590
  #end

  test "Day 16 A" do
    assert D16.a() == 25895
  end

  test "Day 22 A" do
    assert D22.a() == 33421
  end

end
