defmodule MarkovTweets.Generator do

  @max_char_count 140
  @punctuation [?., ?,, ?!, ??, ?:]

  def start(chain) do
    start_seq = chain
                |> Map.keys
                |> Enum.filter(&(elem(&1, 0) === :begin))
                |> Enum.random
    start_acc = start_seq
                |> Tuple.delete_at(0)
                |> Tuple.to_list
    char_count = count_chars(start_acc)

    start(chain, start_seq, start_acc, char_count)
  end

  def start(chain, _, _, char_count) when char_count > @max_char_count do
    start(chain)
  end
  def start(chain, _, acc, _) when (acc |> hd |> hd) == "@" do
    start(chain)
  end
  def start(chain, seq, acc, char_count) do
    case chain[seq] do
      nil ->
        remove_end_token(acc)
      edges ->
        term = Enum.random(edges)
        new_seq = shift(seq, term)
        new_acc = concat(acc, term)
        char_count = count_chars(new_acc)

        start(chain, new_seq, new_acc, char_count)
    end
  end

  defp shift(seq, term) do
    seq
    |> Tuple.delete_at(0)
    |> Tuple.append(term)
  end

  defp concat(acc, [<< t >>] = term) when t in @punctuation do
    acc ++ [term]
  end
  defp concat(acc, term) do
    acc ++ [[" "], term]
  end

  defp count_chars(io_list) do
    io_list
    |> List.flatten
    |> Enum.count
  end

  defp remove_end_token(io_list) do
    io_list
    |> List.flatten
    |> Enum.filter(&String.valid?/1)
    |> List.delete_at(-1) # remove space at the end
  end

end
