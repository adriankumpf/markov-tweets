defmodule MarkovTweets.Chain do
  alias MarkovTweets.Splitter

  @order 2

  def create(source, order \\ @order) do
    source
    |> Stream.map(&create_subchain(&1, order))
    |> Enum.reduce(%{}, &Map.merge(&2, &1, fn _, l1, l2 -> l1 ++ l2 end))
  end

  defp map_seq_to_term(tokens, subchain) do
    [value | key] = Enum.reverse(tokens)

    terms =
      key
      |> Enum.reverse()
      |> List.to_tuple()

    Map.update(subchain, terms, [value], &(&1 ++ [value]))
  end

  defp create_subchain(tweet, order) do
    tweet
    |> Splitter.tokenize()
    |> Enum.chunk_every(order + 1, 1, :discard)
    |> Enum.reduce(%{}, &map_seq_to_term/2)
  end
end
