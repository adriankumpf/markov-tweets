defmodule MarkovTweets.Source do

  def get do
    File.stream!("./dumps/realdonaldtrump.csv")
    |> CSV.decode(headers: true, strip_cells: true)
    |> Stream.filter(fn %{"is_retweet" => is_retweet} -> is_retweet == "False" end)
    |> Stream.map(fn %{"text" => text} -> text end)
  end

end
