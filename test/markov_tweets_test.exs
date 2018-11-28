defmodule MarkovTweetsTest do
  use ExUnit.Case

  doctest MarkovTweets

  alias MarkovTweets.{Splitter, Chain}

  # SPLITTER

  test "it indicates the beginning and ending of a string" do
    assert Splitter.tokenize("") == [:begin, [], :end]
  end

  test "it splits a tweet into tokens" do
    tokens = [
      :begin,
      ["M", "a", "k", "e"],
      ["a", "m", "e", "r", "i", "c", "a"],
      ["d", "r", "u", "m", "p", "f"],
      ["a", "g", "a", "i", "n"],
      ["."],
      :end
    ]

    assert Splitter.tokenize("Make america drumpf again.") == tokens
  end

  test "punctuation gets tokenized" do
    tokens = [
      :begin,
      ["M", "a", "k", "e"],
      ["."],
      ["a", "m", "e", "r", "i", "c", "a"],
      ["!"],
      ["r", "e", "a", "l", "l", "y"],
      [":"],
      ["d", "r", "u", "m", "p", "f"],
      [","],
      ["a", "g", "a", "i", "n"],
      ["?"],
      :end
    ]

    assert Splitter.tokenize("Make. america! really: drumpf, again?") == tokens
  end

  test "tweets with hashtags and handles get tokenized" do
    tokens = [
      :begin,
      [".", "@", "P", "O", "T", "U", "S"],
      ["f", "o", "o"],
      ["b", "a", "r"],
      ["#", "d", "r", "u", "m", "p", "f"],
      :end
    ]

    assert Splitter.tokenize(".@POTUS foo bar #drumpf") == tokens
  end

  # CHAIN

  @ping ["p", "i", "n", "g"]
  @pong ["p", "o", "n", "g"]

  test "it creates a markov chain of order 1" do
    chain = %{{:begin} => [@ping], {@ping} => [@pong, @pong], {@pong} => [@ping, :end]}

    assert Chain.create(["ping pong ping pong"], 1) == chain
  end

  test "it creates a markov chain of order 2" do
    chain = %{
      {:begin, @ping} => [@pong],
      {@ping, @pong} => [@pong, @ping, @ping],
      {@pong, @ping} => [@pong, @pong, :end],
      {@pong, @pong} => [@ping]
    }

    assert Chain.create(["ping pong pong ping pong ping pong ping"], 2) == chain
  end

  test "it creates a markov chain of order 4" do
    str = ["ping pong ping pong ping pong ping pong ping pong ping pong ping pong"]

    chain = %{
      {:begin, @ping, @pong, @ping} => [@pong],
      {@ping, @pong, @ping, @pong} => [@ping, @ping, @ping, @ping, @ping, :end],
      {@pong, @ping, @pong, @ping} => [@pong, @pong, @pong, @pong, @pong]
    }

    assert Chain.create(str, 4) == chain
  end
end
