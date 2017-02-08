defmodule MarkovTweets do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(MarkovTweets.Worker, []),
    ]

    opts = [strategy: :one_for_one, name: MarkovTweets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def tweet do
    IO.puts MarkovTweets.Worker.tweet()
  end

end
