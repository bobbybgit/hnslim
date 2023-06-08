module GamesHelper

  def rated_check(game, user)
    game.ratings.where(user_id: user).first.present? ? game.ratings.where(user_id: user).first.rating : "8"
  end

end
