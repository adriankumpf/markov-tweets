defmodule MarkovTweets.Mixfile do
  use Mix.Project

  def project do
    [
      app: :markov_tweets,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {MarkovTweets, []}
    ]
  end

  defp deps do
    [{:httpoison, "~> 1.4"}, {:jason, "~> 1.1"}]
  end

  defp aliases do
    [test: "test --no-start"]
  end
end
