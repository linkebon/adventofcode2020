defmodule D22 do
  def a() do
    deck = Read_File_Utils.read_file("22.txt", ~r/\n\n/)

    p1_cards = Enum.at(deck, 0)
               |> String.split(~r/:/)
               |> Enum.at(1)
               |> String.trim_leading()
               |> String.split(~r/\n/)
               |> Enum.map(&String.to_integer() / 1)

    p2_cards = Enum.at(deck, 1)
               |> String.split(~r/:/)
               |> Enum.at(1)
               |> String.trim_leading()
               |> String.split(~r/\n/)
               |> Enum.map(&String.to_integer() / 1)

    run_cards(p1_cards, p2_cards)
    |> calculate_score
  end

  def run_cards([p1_h | p1_t], [p2_h | p2_t]) do
    cond do
      p1_h > p2_h -> run_cards(p1_t ++ [p1_h] ++ [p2_h], p2_t)
      true -> run_cards(p1_t, p2_t ++ [p2_h] ++ [p1_h])
    end
  end

  def run_cards([], [h | t]), do: [h | t]

  def run_cards([h | t], []), do: [h | t]

  def calculate_score(winners_cards) do
    Enum.reduce(
      Enum.with_index(Enum.reverse(winners_cards)),
      0,
      fn {t, idx}, acc ->
        acc + t * (idx + 1)
      end
    )
  end

end
