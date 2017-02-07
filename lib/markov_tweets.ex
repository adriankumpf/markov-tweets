defmodule MarkovTweets do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
       worker(MarkovTweets.Chain, []),
    ]

    opts = [strategy: :one_for_one, name: MarkovTweets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def generate do
    tweet = MarkovTweets.Chain.generate

    # Task.async(fn ->
    #   System.cmd "say", ["-v", "Alex", to_string(tweet)]
    # end)

    IO.puts tweet
  end

end
