module GamesHelper

  def rated_check(game)
    @ratings[game.id] || "8"
  end

end
