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

defmodule D22B do
  def b() do
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

  def run_cards([p1_h | p1_t], [p2_h | p2_t], previous_decks \\ MapSet.new(), sub_game? \\ false) do
    IO.inspect([p1_h | p1_t], label: "player 1 deck")
    IO.inspect([p2_h | p2_t], label: "player 2 deck")
    cond do
      MapSet.member?(previous_decks, [p1_h | p1_t]) or MapSet.member?(previous_decks, [p2_h | p2_t]) ->
        IO.puts("Same cards in deck as previous round. P1 wins")
        :p1

      sub_game? ->
        cond do
          p1_h > p2_h ->
            previous_decks = previous_decks
                             |> MapSet.put([p1_h | p1_t])
                             |> MapSet.put([p2_h | p2_t])
            run_cards(p1_t ++ [p1_h] ++ [p2_h], p2_t, previous_decks, true)

          true ->
            previous_decks = previous_decks
                             |> MapSet.put([p1_h | p1_t])
                             |> MapSet.put([p2_h | p2_t])
            run_cards(p1_t, p2_t ++ [p2_h] ++ [p1_h], previous_decks, true)
        end

      p1_h <= Enum.count(p1_t) and p2_h <= Enum.count(p2_t) ->
        IO.puts("Staring sub game")
        previous_decks = previous_decks
                         |> MapSet.put([p1_h | p1_t])
                         |> MapSet.put([p2_h | p2_t])
        case run_cards(
               Enum.slice(p1_t, 0..p1_h - 1)
               |> IO.inspect(label: "p1 copy deck"),
               Enum.slice(p2_t, 0..p2_h - 1)
               |> IO.inspect(label: "p2 copy deck"),
               previous_decks,
               true
             ) do
          :p1 ->
            IO.puts("P1 wins subgame")
            run_cards(p1_t ++ [p1_h] ++ [p2_h], p2_t, previous_decks, false)

          :p2 ->
            IO.puts("P2 wins subgame")
            run_cards(p1_t, p2_t ++ [p2_h] ++ [p1_h], previous_decks, false)

          _ -> throw("game failed")
        end

      p1_h > p2_h ->
        IO.puts("P1 wins")
        previous_decks = previous_decks
                         |> MapSet.put([p1_h | p1_t])
                         |> MapSet.put([p2_h | p2_t])
        run_cards(p1_t ++ [p1_h] ++ [p2_h], p2_t, previous_decks, false)

      true ->
        IO.puts("P2 wins")
        previous_decks = previous_decks
                         |> MapSet.put([p1_h | p1_t])
                         |> MapSet.put([p2_h | p2_t])
        run_cards(p1_t, p2_t ++ [p2_h] ++ [p1_h], previous_decks, false)
    end
  end

  def run_cards([], [h | t], _, false), do: [h | t]

  def run_cards([h | t], [], _, false), do: [h | t]

  def run_cards([h | t], [], _, true), do: :p1

  def run_cards([], [h | t], _, true), do: :p2

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
