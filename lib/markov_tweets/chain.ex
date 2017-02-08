defmodule MarkovTweets.Chain do

  alias MarkovTweets.Source
  alias MarkovTweets.Splitter

  @order 2

  def create(order \\ @order) do
    Source.get
    |> Stream.map(&create_subchain(&1, order))
    |> merge
  end

  defp create_subchain(tweet, order) do
    tweet
    |> Splitter.tokenize
    |> Enum.chunk(order + 1, 1)
    |> Enum.reduce(%{}, fn tokens, acc ->
      [value | key] = Enum.reverse(tokens)
      terms = key
              |> Enum.reverse
              |> List.to_tuple

      acc |> Map.update(terms, [value], &(&1 ++ [value]))
    end)
  end

  defp merge(chains) do
    Enum.reduce(chains, %{}, &Map.merge(&2, &1, fn _, v1, v2 ->
      v1 ++ v2
    end))
  end

end
