defmodule MarkovTweets.Generator do

  def built(chain) do
    start_seq = chain
                |> Map.keys
                |> Enum.filter(&(elem(&1, 0) === :begin))
                |> Enum.random
    start_acc = start_seq
                |> Tuple.delete_at(0)
                |> Tuple.to_list

    built(chain, start_seq, start_acc)
  end

  def built(chain, seq, acc) do
    case chain[seq] do
      nil ->
        List.delete_at(acc, -1)
      edges ->
        term = Enum.random(edges)
        new_seq = seq
                  |> Tuple.delete_at(0)
                  |> Tuple.append(term)

        built(chain, new_seq, acc ++ [[" "], term])
    end
  end

end
