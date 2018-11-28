defmodule MarkovTweets.Downloader do
  alias HTTPoison.Response

  @url "http://www.trumptwitterarchive.com/data/realdonaldtrump"
  @start_year 2009

  def stream!(file_name) do
    @start_year..year()
    |> Task.async_stream(&download!/1, timeout: 15_000)
    |> Stream.flat_map(fn {:ok, tweets} -> tweets end)
    |> Stream.filter(fn %{"is_retweet" => is_retweet} -> not is_retweet end)
    |> Stream.map(fn %{"text" => text} -> text <> "\n" end)
    |> Stream.into(File.stream!(file_name))
  end

  defp download!(year) do
    with {:ok, %Response{status_code: 200, body: body}} <- HTTPoison.get(@url <> "/#{year}.json"),
         {:ok, body} <- Jason.decode(body) do
      body
    else
      {:error, reason} -> raise "Download failed: #{inspect(reason)}"
    end
  end

  defp year do
    Date.utc_today().year
  end
end
