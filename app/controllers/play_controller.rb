class PlayController < ApplicationController

  class PlayGroup
    def initialize(params)
      @error = nil
      @group_sizes = set_group_sizes(params)
      pp @group_sizes
      @players = set_players(params)
      @spaces = Array.new(player_count,0)
      

      @collection = set_collection(params)
      @collection.present? ? @games = set_games(params) : error = "No games found, please add games or add players with existing collections"
      @error = "Group sizes not achievable with player count, please either amend group sizes or add or remove players" if group_error_check(params)
      @games_for_spaces = set_game_spaces(params)
      if !error.present?
        @player_scores = set_player_scores
        @games_combos = set_games_combos(params) 
        pp @games_combos.count       
      end      
    end

    def nested_hash
      Hash.new { |h, k| h[k] = nested_hash }
    end

    def get_game_spaces
      @games_for_spaces
    end

    

    def set_game_spaces(params)
      game_slots = @games.flat_map { |game| [game.id] * [game.max_players, params[:group_size_max]].min }
      #game_combos = generate_combinations(game_slots, player_count, params[:group_size_min])
    end

    def get_players
      @players
    end

    def get_games
      @games
    end

    def get_scores
      @player_scores
    end

    def get_group_rankings(group)
      @group_scores[group]
    end

    def get_group_scores
      @group_scores
    end

    def get_group_score(group, game)
      @group_scores[group][game]
    end

    def combo_score_generator(combo)
      score = 0
      combo.each do |group|
        score = score + get_group_score(group[0],group[1])
      end
      return score
    end

    

    def get_rankings
      
      top_combo = [0,0]

      @combos.each do |combo|
        possible_game_combos = @games_combos.select{ |a| a.length == combo.length}       
        possible_game_combos.each_with_object({}).with_index do |(game_combo, poss_combos),i|
          
          poss_combos[i] = combo.product(game_combo).combination(game_combo.length).to_a.select{|a| (a.map{ |b| b[0]}.length == a.map{ |b| b[0]}.uniq.length) && (a.map{ |b| b[1]}.length == a.map{ |b| b[1]}.uniq.length)}
          poss_combos[i].each_with_index do | c,ind |
            combo_score = combo_score_generator(poss_combos[i][ind])
            top_combo = [poss_combos[i][ind],combo_score] if combo_score > top_combo[1]
          end
            
        end
          
      end

        return top_combo 
                      
    end

    def set_games_combos(params)
      @games_for_spaces.combination(player_count)
      #gc = @games_for_spaces.combination(player_count).select{ |combo| combo.uniq.map{ |spot| [spot,combo.count(spot)]}.none?{|game| pp game; game[1] < @player_scores[game[0]][:min_players]} }
    end

    def set_players(params)
      user_ids = params.select{ |k, v| (k.start_with? "attend") && (v == "1") }.keys.map{|k| k.tr("attend","").to_i}
      User.where(id: user_ids)
    end

    def set_collection(params)
      collection_ids = params.select{ |k, v| (k.start_with? "collection") && (v == "1") }.keys.map{|k| k.tr("collection","").to_i}
      Collection.where(user_id:collection_ids)
    end

    def set_games(params)
      @games = Game.all
    end

    def set_group_sizes(params)
      if (params[:group_size_min] != params[:group_size_max])
        @group_sizes = *(params[:group_size_min].to_i..params[:group_size_max].to_i)
      else
        @group_sizes = [[params[:group_size_min].to_i,params[:group_size_max].to_i]]
      end
    end

    def group_error_check(params)
      (params[:group_size_min].to_i > params[:group_size_max].to_i) || (params[:group_size_min].to_i > player_count) || !GroupCheck.check_group(@group_sizes,player_count)
    end

    def set_groups(params)
      (params[:group_size_min].to_i..params[:group_size_max].to_i).flat_map{|group_size| @players.map{ |player| player.id}.combination(group_size).to_a}
    end

    def set_combos(params)
      @combos = []
      for a in (player_count/params[:group_size_max].to_i..player_count/params[:group_size_min].to_i) do
        new_combos = @groups.repeated_permutation(a).to_a
        @combos = @combos.concat(new_combos)
      end
      @combos = @combos.select{ |a| a.flatten.uniq.length == player_count()}.select{ |b| b.flatten == b.flatten.uniq}.map{ |c| c.sort }.uniq
    end

    

    def set_options(params)
      Game.all.play_time(params[:min_length], params[:max_length], params[:time]).by_weight(params[:min_weight],params[:max_weight]).by_players(params[:group_size_min],params[:group_size_max])
    end

    def player_count
      @players.length
    end

    def set_player_scores
    
      @games.each_with_object(nested_hash) do |game, scores|
        scores[game.id][:min_players] = game.min_players
        scores[game.id][:max_players] = game.max_players
        @players.each do |player|
           rating = Rating.where(user_id: player.id, game_id: game.id).first if Rating.where(user_id: player.id, game_id: game.id).first.present?
           rating.present? ? score = rating.rating : score = 0
          scores[game.id][player.id] = Rating.translate_rating(score)
        end
      end     

    end

  end

  def new
    
  end

  def options
    @players = User.all
  end

  def results
    @error = nil
    @playgroup = PlayGroup.new(params)
    @rankings = @playgroup.get_rankings
    @players = @playgroup.get_players
    @games = @playgroup.get_games
    pp @error if @error.present?
  end

  private

  
 
  

  

  
  

end
