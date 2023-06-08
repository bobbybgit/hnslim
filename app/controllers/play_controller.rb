class PlayController < ApplicationController

  def new
    
  end

  def player_select
    @players = User.all 
    params[:num_players].present? ? @num_players = params[:num_players].to_i : @num_players = 2
    pp @num_players
  end

  def options
  end

  def results
    @error = nil
    @players = set_players(params)
    
    if @players.length < params.select{ |e| e.start_with? "player" }.values.length 
      @error = "Duplicate player selected, please lower player count or ensure all players are unique"
    else
      group_sizes = *(params[:group_size_min].to_i..params[:group_size_max].to_i)
      if (params[:group_size_min].to_i > params[:group_size_max].to_i) || (params[:group_size_min].to_i > @players.length) || (params[:group_size_max].to_i > @players.length) || !GroupCheck.check_group(group_sizes,@players.length)
        @error = "There is an issue with player count. Please check group sizes work with player count and aren't higher than total player count, then retry"
        pp GroupCheck.check_group(group_sizes,params[:group_size])
      else
        @games = set_options(params).where(id: set_collection(params, @players).map{|collection| collection.game_id})
        pp @games.map{ |game| game.name}
        @groups = (params[:group_size_min].to_i..params[:group_size_max].to_i).flat_map{|group_size| @players.map{ |player| player.id}.combination(group_size).to_a}
        pp @groups
      end
    end
    pp @error if @error.present?
  end

  private

  def set_players(params)
    User.where(id: params.select{ |e| e.start_with? "player" }.values)
  end

  def set_options(params)
    
    Game.all.play_time(params[:min_length], params[:max_length], params[:time]).by_weight(params[:min_weight],params[:max_weight]).by_players(params[:group_size_min],params[:group_size_max])

  end

  def set_collection(params, players)
    non_player = nil
    non_player = User.find_by_id(params[:collection]) if params[:collection].present? && params[:collection] != "None"  
    non_player.present? ? collection_users = players.map{|player| player.id} + non_player.id : collection_users = players.map{|player| player.id}
    Collection.where(user_id: collection_users)
  end

end
