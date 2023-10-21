class PlayGroup
  def initialize(params)
    @error = nil
    @group_sizes = set_group_sizes(params)
    pp @group_sizes
    @players = set_players(params)
    @collection = set_collection(params)
    @collection.present? ? @games = set_games(params) : @error = "No rated games found, please add games or add players with existing collections, or go and rate some games!"
    params[:group_size_max] = player_count if player_count < params[:group_size_min].to_i
    @error = "Group sizes not achievable with player count, please either amend group sizes or add or remove players" if group_error_check(params)
    if !@error.present?
      @groups = set_groups(params)
      @group_combinations = combine_groups(params)
      @player_scores = set_player_scores
      @group_scores = calculate_group_scores(params)
      pp " scores: #{@group_scores}"
      !@group_scores[0].first[1].empty? ? @final_scores = calculate_final_scores(params) : @error = "No rated games meet criteria, please adjust options and try again, or go and rate some games!"
      end      
  end

  def nested_hash
    Hash.new { |h, k| h[k] = nested_hash }
  end

  def get_groups 
    @groups
  end

  def get_final_scores
    @final_scores
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

  def set_players(params)
    user_ids = params.select{ |k, v| (k.start_with? "attend") && (v == "1") }.keys.map{|k| k.tr("attend","").to_i}
    User.where(id: user_ids)
  end

  def get_error
    @error
  end

  def calculate_group_scores(params)
    scores = groups_map(params)
  end

  def groups_map(params)
    @groups.map{|group| {group => games_map(group,params)}}
  end

  def games_map(group,params)
    ratings = Rating.where user_id: group, game_id: @games
    @games.select{|g| players_check(g,group,params[:rec])}.map{ |game| [game.id, sum_ratings(group,game,ratings)]}.sort(){|a,b| [b[1],[1,4].sample] <=> [a[1],[2,3].sample]}
  end

  def players_check(game,group,rec)
    if rec == "1"
      (game.min_rec_players > group.count) || (game.max_rec_players < group.count) ? false : true
    else
      (game.min_players > group.count) || (game.max_players < group.count) ? false : true
    end
  end

  def sum_ratings(group, game, ratings)
    group.map{|player| get_rating(game.id,player,ratings)}.sum
  end

  def get_rating(game_id, user_id, ratings)
    rating = ratings.find { |r| r.game_id == game_id && r.user_id == user_id }
    rating = rating.rating if rating
    Rating.translate_rating(rating)
  end

  def calculate_final_scores(params)
    
    top_combo = Hash.new
    game_selection = Hash.new

    def check_dups(game_selection)
      game_selection.select{|group| game_selection.map{|group_sel| group_sel[2][0]}.count(group[2][0]) > 1}.count > 0 ? true : false
    end

    @group_combinations.each do |combo|
      game_selection = @group_scores.select{|group| combo.include?(group.keys.first) }.flat_map{|group| group.map{|group_ids,games| [group_ids, 0, games.first]}}
      while check_dups(game_selection)
        next_highest = [nil,0,[0,0]]
        highest_index = 0
        game_selection.each_with_index do |grouping,i|
          if @group_scores[@group_scores.index{|i| i.keys.first == grouping[0]}].values[0][grouping[1]+1][1] > next_highest[2][1] 
            next_highest = [grouping[0],grouping[1]+1,@group_scores[@group_scores.index{|i| i.keys.first == grouping[0]}].values[0][grouping[1]+1]]
            highest_index = i 
          end
        end         
        game_selection[highest_index] = next_highest
      end
      rand = [true,false].sample
      pp "#{rand} #{game_selection[0]}"
      top_combo = game_selection if top_combo.empty? || game_selection.map{|group| group[2][1]}.sum > top_combo.map{|group| group[2][1]}.sum || ((game_selection.map{|group| group[2][1]}.sum == top_combo.map{|group| group[2][1]}.sum) && rand)
    end
    top_combo      

    
  end

  def set_collection(params)
    collection_ids = params.select{ |k, v| (k.start_with? "collection") && (v == "1") }.keys.map{|k| k.tr("collection","").to_i}
    Collection.where(user_id:collection_ids)
  end

  def set_games(params)
    @games = Game.where(id: @collection.pluck(:game_id)).by_players(params[:group_size_min],params[:group_size_max],params[:rec]).by_weight(params[:min_weight],params[:max_weight]).play_time(params[:min_length],params[:max_length], params[:max_length])
  end

  def set_group_sizes(params)
    if (params[:group_size_min] != params[:group_size_max])
      @group_sizes = *(params[:group_size_min].to_i..params[:group_size_max].to_i)
    else
      @group_sizes = [params[:group_size_min].to_i,params[:group_size_max].to_i]
    end
  end

  def group_error_check(params)
    (params[:group_size_min].to_i > params[:group_size_max].to_i) || (params[:group_size_min].to_i > player_count) || !GroupCheck.check_group(@group_sizes,player_count)
  end

  def set_groups(params)
    (params[:group_size_min].to_i..params[:group_size_max].to_i).flat_map{|group_size| @players.map{ |player| player.id}.combination(group_size).to_a}
  end

  def get_group_combinations
    @group_combinations
  end

  def combine_groups(params)
    combos = []
    for a in (player_count/params[:group_size_max].to_i..player_count/params[:group_size_min].to_i) do
      new_combos = @groups.repeated_permutation(a).to_a
      combos = combos.concat(new_combos)
      pp a
    end
    validate_groups(combos)
  end

  def validate_groups(combos)
    combos.select{ |a| a.flatten.uniq.length == player_count()}.select{ |b| b.flatten == b.flatten.uniq}.map{ |c| c.sort }.uniq
  end
  

  def set_options(params)
    Game.all.play_time(params[:min_length], params[:max_length], params[:time]).by_weight(params[:min_weight],params[:max_weight]).by_players(params[:group_size_min],params[:group_size_max])
  end

  def player_count
    @players.length
  end

  def set_player_scores
    @ratings = Rating.where user_id: @players, game_id: @games
    @games.each_with_object(nested_hash) do |game, scores|
      scores[game.id][:min_players] = game.min_players
      scores[game.id][:max_players] = game.max_players
      @players.each do |player|
        rating = @ratings.find { |r| r.user_id == player.id && r.game_id == game.id }
        rating.present? ? score = rating.rating : score = 0
        scores[game.id][player.id] = Rating.translate_rating(score)
      end
    end     
  end
end
