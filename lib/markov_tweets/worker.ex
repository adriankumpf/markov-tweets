defmodule MarkovTweets.Worker do
  use GenServer

  alias MarkovTweets.Chain
  alias MarkovTweets.Generator

  #######
  # API #
  #######

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def generate do
    GenServer.call(__MODULE__, :generate_tweet)
  end

  #############
  # Callbacks #
  #############

  def init(:ok) do
    chain = "./dumps/realdonaldtrump.txt"
            |> File.stream!
            |> Chain.create

    {:ok, chain}
  end

  def handle_call(:generate_tweet, _, chain) do
    {:reply, Generator.built(chain), chain}
  end

end
