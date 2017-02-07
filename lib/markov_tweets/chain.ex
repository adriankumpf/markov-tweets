defmodule MarkovTweets.Chain do

  alias MarkovTweets.Splitter

  def init(tweet_stream, order) do
    tweet_stream
    |> Stream.map(&generate(&1, order))
    |> Enum.reduce(%{}, &Map.merge(&2, &1, fn _k, v1, v2 -> v1 ++ v2 end))
  end

  def generate(tweet, order) do
    tweet
    |> Splitter.tokenize
    |> Enum.chunk(order + 1, 1)
    |> Enum.reduce(%{}, fn tokens, acc ->
      [value | key] = Enum.reverse(tokens)
      terms = key |> Enum.reverse |> List.to_tuple

      acc |> Map.update(terms, [value], &(&1 ++ [value]))
    end)
  end

end
