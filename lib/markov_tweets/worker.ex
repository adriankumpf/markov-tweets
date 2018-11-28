defmodule MarkovTweets.Worker do
  use GenServer

  require Logger

  alias MarkovTweets.{Chain, Generator, Downloader}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def generate do
    GenServer.call(__MODULE__, :generate_tweet)
  end

  @impl true
  def init(_opts) do
    {:ok, Chain.create(tweet_dump())}
  end

  @impl true
  def handle_call(:generate_tweet, _, chain) do
    {:reply, Generator.start(chain), chain}
  end

  defp tweet_dump do
    path = Application.get_env(:markov_tweets, :dump)

    case File.exists?(path) do
      true ->
        Logger.debug("Loading tweet dump ...")
        File.stream!(path)

      false ->
        Logger.debug("Downloading tweet dump ...")
        Downloader.stream!(path)
    end
  end
end
