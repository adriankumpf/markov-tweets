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
    IO.puts(tweet)
  end

end
