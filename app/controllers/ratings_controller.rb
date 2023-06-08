class RatingsController < ApplicationController

  def new
    if Rating.where(game_id: params[:game_id], user_id: current_user.id).present?
      rating = Rating.where(game_id: params[:game_id], user_id: current_user.id).first
      rating.destroy
    end

    rating = Rating.new do |r|
      r.game_id = params[:game_id]
      r.rating = params[:rating]
      r.user_id = current_user.id
    end

    rating.save

    redirect_to confirm_rating_path, turbo_frame: "content"

  end

  def confirm
  end

end
