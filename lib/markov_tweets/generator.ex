defmodule MarkovTweets.Generator do

  @max_char_count 140
  @punctuation [?., ?,, ?!, ??, ?:]

  def built(chain) do
    start_seq = chain
                |> Map.keys
                |> Enum.filter(&(elem(&1, 0) === :begin))
                |> Enum.random
    start_acc = start_seq
                |> Tuple.delete_at(0)
                |> Tuple.to_list
    char_count = count_chars(start_acc)

    built(chain, start_seq, start_acc, char_count)
  end

  def built(chain, _, _, char_count) when char_count > @max_char_count do
    built(chain)
  end
  def built(chain, seq, acc, char_count) do
    case chain[seq] do
      nil ->
        List.delete_at(acc, -1) # delete :end token
      edges ->
        term = Enum.random(edges)
        new_seq = seq
                  |> Tuple.delete_at(0)
                  |> Tuple.append(term)
        new_acc = acc ++ prepend_space(term)
        char_count = count_chars(new_acc)

        built(chain, new_seq, new_acc, char_count)
    end
  end

  defp prepend_space([<< t::utf8 >>] = term) when t in @punctuation do
    [term]
  end
  defp prepend_space(term) do
    [[" "], term]
  end

  defp count_chars(io_list) do
    io_list
    |> List.flatten
    |> Enum.count
  end

end
