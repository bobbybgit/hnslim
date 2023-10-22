module GamesHelper

  def rated_check(game)
    current_user.ratings.find { |r| r.game_id == game.id }&.rating || "8"
  end

end
