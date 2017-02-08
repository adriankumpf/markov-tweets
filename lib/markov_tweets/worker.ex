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

  def tweet do
    GenServer.call(__MODULE__, :generate_tweet)
  end

  #############
  # Callbacks #
  #############

  def init(:ok) do
    {:ok, Chain.create()}
  end

  def handle_call(:generate_tweet, _, chain) do
    {:reply, Generator.built(chain), chain}
  end

end
