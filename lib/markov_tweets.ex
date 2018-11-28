defmodule MarkovTweets do
  use Application

  alias __MODULE__.Worker

  def start(_type, _args) do
    children = [
      Worker
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MarkovTweets.Supervisor)
  end

  def generate do
    Worker.generate() |> to_string()
  end
end
