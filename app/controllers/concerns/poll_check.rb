module PollCheck
  def self.players(game)
      polls = game["poll"]
      poll_position = "X"
      polls.each_with_index do |poll, i|
          poll_position = i if poll["name"] == "suggested_numplayers"
      end
      
      playercounts = [game["minplayers"][0]["value"],game["maxplayers"][0]["value"]]

      return playercounts if poll_position.class != Integer || polls[poll_position]["results"]

      playercounts = []
          
      playervotes = polls[poll_position]["results"]
      
      upvotes = downvotes = 0
      playervotes.each do |playercount|
          playercount["result"].each do |result|
              upvotes = result["numvotes"] if (result["value"] == "Recommended") || (result["value"] == "Best")
              downvotes = result["numvotes"] if result["value"] == "Not Recommended"
          end
          playercounts.push(playercount["numplayers"]) if upvotes > downvotes
      end
      puts "#{playercounts} PLAYERS"
      return playercounts

  end
end