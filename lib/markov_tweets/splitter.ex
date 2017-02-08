defmodule MarkovTweets.Splitter do

  @url_placeholder ~w( h t t p : / / s o m e . l i n k )
  @punctuation [?., ?,, ?!, ??, ?:]
  @empty_word []
  @remove [?", ?(, ?)]

  def tokenize(tweet) do
    tweet
    |> String.trim
    |> tokenize(@empty_word, [])
  end

  def tokenize(<< p, ?\s, rest::binary >>, word, acc) when p in @punctuation do
    tokenize(rest, @empty_word, acc ++ [word, [<< p >>]])
  end
  def tokenize(<< r, rest::binary >>, word, acc) when r in @remove do
    tokenize(rest, word,  acc)
  end
  def tokenize(<< p  >>, word, acc) when p in @punctuation do
    tokenize("", [<< p >>], add_word(acc, word))
  end
  def tokenize(<< ?\s, rest::binary >>, word, acc) do
    tokenize(rest, @empty_word, add_word(acc, word))
  end
  def tokenize(<< ?\n, rest::binary >>, word, acc) do
    tokenize(rest, @empty_word, add_word(acc, word))
  end
  def tokenize(<< "&amp;", rest::binary >>, word, acc) do
    tokenize(rest, word ++ ["&"], acc)
  end
  def tokenize(<< "http", rest::binary >>, @empty_word, acc) do
    tokenize(rest, @url_placeholder, acc)
  end
  def tokenize(<< _, rest::binary >>, @url_placeholder = word, acc) do
    tokenize(rest, word, acc)
  end
  def tokenize(<< c, rest::binary >>, word, acc) do
    tokenize(rest, word ++ [<< c >>], acc)
  end
  def tokenize(<< >>, word, acc) do
    [:begin] ++ add_word(acc, word) ++ [:end]
  end

  def add_word(acc, @empty_word), do: acc
  def add_word(acc, word), do: acc ++ [word]

end
