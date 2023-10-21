module GamesHelper

  def rated_check(game, user)
    current_user.ratings.find { |r| r.game_id == game.id } || "8"
  end

end
