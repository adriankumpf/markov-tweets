defmodule MarkovTweets.Splitter do

  @punctuation [?., ?,, ?!, ??, ?:]
  @empty_word []

  def tokenize(tweet) do
    tweet
    |> String.trim
    |> tokenize(@empty_word, [])
  end

  def tokenize(<< p::utf8, ?\s::utf8, rest::binary >>, word, acc) when p in @punctuation do
    tokenize(rest, @empty_word, acc ++ [word, [<< p >>]])
  end
  def tokenize(<< p::utf8, "" >>, word, acc) when p in @punctuation do
    tokenize("", [<< p >>], add_word(acc, word))
  end
  def tokenize(<< ?\s::utf8, rest::binary >>, word, acc) do
    tokenize(rest, @empty_word, add_word(acc, word))
  end
  def tokenize(<< ?\"::utf8, rest::binary >>, word, acc) do
    tokenize(rest, word,  acc)
  end
  def tokenize(<< c::utf8, rest::binary >>, word, acc) do
    tokenize(rest, word ++ [<< c >>], acc)
  end
  def tokenize(<< >>, word, acc) do
    [:begin] ++ add_word(acc, word) ++ [:end]
  end

  def add_word(acc, @empty_word), do: acc
  def add_word(acc, word), do: acc ++ [word]

end
