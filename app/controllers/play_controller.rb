class PlayController < ApplicationController
  def new
    @error = nil
    if Group.joins(:memberships).where(memberships:{user_id: current_user.id}).first.present?
      @groups = Group.joins(:memberships).where(memberships:{user_id: current_user.id})
    else
      @error = "Please join a group before planning a play"
    end

  end

  def options
    params[:group].present? ? @players = User.where(id: Group.find_by_id(params[:group]).users.map(&:id)) : @players = User.where(id: Group.joins(:memberships).where(memberships:{user_id: current_user.id}).first.users.map(&:id))
    
  end

  def results
    @error = nil

    @playgroup = PlayGroup.new(params)
    @rankings = @playgroup.get_final_scores
    @players = @playgroup.get_players
    @games = @playgroup.get_games
    @error = @playgroup.get_error if @playgroup.get_error.present?
    pp @error if @error.present?
  end
end
