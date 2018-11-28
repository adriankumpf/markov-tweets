defmodule MarkovTweets.Worker do
  use GenServer

  alias MarkovTweets.{Chain, Generator}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def generate do
    GenServer.call(__MODULE__, :generate_tweet)
  end

  @impl true
  def init(_opts) do
    chain =
      "./dumps/realdonaldtrump.txt"
      |> File.stream!()
      |> Chain.create()

    {:ok, chain}
  end

  @impl true
  def handle_call(:generate_tweet, _, chain) do
    {:reply, Generator.start(chain), chain}
  end
end
