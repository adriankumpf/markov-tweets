defmodule MarkovTweets.Chain do
  use GenServer

  alias MarkovTweets.Splitter
  alias MarkovTweets.Generator

  @order 2

  #######
  # API #
  #######

  def start_link do
    GenServer.start_link(__MODULE__, @order, name: __MODULE__)
  end

  def generate do
    GenServer.call(__MODULE__, :generate)
  end

  #############
  # Callbacks #
  #############

  def init(order) do
    source = File.stream!("./dumps/realdonaldtrump.csv")
             |> CSV.decode(headers: true, strip_cells: true)
             |> Stream.filter(fn %{"text" => text, "is_retweet" => is_retweet} ->
               is_retweet == "False" && !String.match?(text, ~r/^"?@/)
             end)
             |> Stream.map(fn %{"text" => text} -> text end)

    chain = source
            |> Stream.map(&create_subchain(&1, order))
            |> merge

    {:ok, chain}
  end

  def handle_call(:generate, _from, chain) do
    tweet = Generator.built(chain)
    {:reply, tweet, chain}
  end

  ###########
  # PRIVATE #
  ###########

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
