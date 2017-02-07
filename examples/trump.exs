File.stream!("./examples/dumps/realDonaldTrump.txt")
|> MarkovTweets.Chain.init(2)
|> MarkovTweets.Generator.built
|> IO.puts
