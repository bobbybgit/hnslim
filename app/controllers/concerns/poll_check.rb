module PollCheck
  def self.players(game)
      polls = game["poll"]
      poll_position = "X"
      polls.each_with_index do |poll, i|
          poll_position = i if poll["name"] == "suggested_numplayers"
          pp "#{poll["name"]} #{poll_position}"
      end
      pp poll_position.class
      
      playercounts = [game["minplayers"][0]["value"],game["maxplayers"][0]["value"]]

      return playercounts if poll_position.class != Integer || polls[poll_position]["results"].empty?

      playercounts = []
          
      playervotes = polls[poll_position]["results"]
      
      
      playervotes.each do |playercount|
          upvotes = downvotes = 0
          playercount["result"].each do |result|
              upvotes += result["numvotes"].to_i if (result["value"] == "Recommended") || (result["value"] == "Best")
              downvotes += result["numvotes"].to_i if result["value"] == "Not Recommended"
          end
          playercounts.push(playercount["numplayers"]) if upvotes >= downvotes
      end
      pp "#{playercounts} PLAYERS"
      playercounts[-1] = game["maxplayers"][0]["value"] if playercounts[-1][-1] == "+"
      pp "#{playercounts} PLAYERS"
      return playercounts

  end
end