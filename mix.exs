defmodule MarkovTweets.Mixfile do
  use Mix.Project

  def project do
    [app: :markov_tweets,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {MarkovTweets, []}]
  end

  defp deps do
    [
      {:csv, "~> 1.4.2"}
    ]
  end
end
