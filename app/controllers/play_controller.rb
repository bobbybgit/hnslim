class PlayController < ApplicationController

  def new
    
  end

  def options
    @players = User.all
  end

  def results
    @error = nil
    @players = set_players(params)
    
    group_sizes = *(params[:group_size_min].to_i..params[:group_size_max].to_i)
    if (params[:group_size_min].to_i > params[:group_size_max].to_i) || (params[:group_size_min].to_i > @players.length) || !GroupCheck.check_group(group_sizes,@players.length)
      @error = "Group sizes not achievable with player count, please either amend group sizes or add or remove players"
    else
      @games = set_options(params).where(id: set_collection(params, @players).map{|collection| collection.game_id})
      pp @games.map{ |game| game.name}
      @groups = (params[:group_size_min].to_i..params[:group_size_max].to_i).flat_map{|group_size| @players.map{ |player| player.id}.combination(group_size).to_a}
      pp @groups
      if @games.length == 0
        @error = "No games meet the requirements, please reconfigure options or add more games"
      else
        groups_with_score = @groups.map{ |group| [group,@games.map{ |game| [game.id, Rating.joins(:game, :user).where(game_id: game.id, user_id: group).map{ |player| Rating.translate_rating(player.rating)}.sum]}]}
        groups_with_score.each do |group|
          group[1].sort!{ |a, b| b[1] <=> a[1]}
        end
        pp groups_with_score

        rankings = set_rankings(groups_with_score, @players.length)
        #scores = @games.map{ |game| [game.id, @players.map{|player| Rating.joins(:game, :user).where(game_id: game.id, user_id: player.id).first.present? ? [player.id, Rating.translate_rating(Rating.joins(:game, :user).where(game_id: game.id, user_id: player.id).first.rating)] : [player.id, 0]}.to_h]}.to_h
        #@group_scores = set_group_scores(scores, @groups, @games)
        #@rankings = set_rankings(@group_scores, @groups, @games, @players)

      
        
      end
    end
    pp @error if @error.present?
  end

  private

  def set_group_scores(scores, groups, games)
    group_score = Hash.new
    groups.each_with_index  do |group, i|
      group_score[group] = Hash.new
      games.each  do |game|
        group_score[group][game.id] = scores[game.id].values_at(*group).sum
      end
      group_score[group] = group_score[score].sort_by{ |k,v| v}
    end
    pp group_score
    group_score
  end

  def set_players(params)

    user_ids = params.select{ |k, v| (k.start_with? "attend") && (v == "1") }.keys.map{|k| k.tr("attend","").to_i}
    User.where(id: user_ids)

  end

 
  def set_options(params)
    
    Game.all.play_time(params[:min_length], params[:max_length], params[:time]).by_weight(params[:min_weight],params[:max_weight]).by_players(params[:group_size_min],params[:group_size_max])

  end

  def set_collection(params, players)
    
    collection_ids = params.select{ |k, v| (k.start_with? "collection") && (v == "1") }.keys.map{|k| k.tr("collection","").to_i}
    Collection.where(user_id:collection_ids)

  end

  def recursive_check(groups_with_score, length, combined_groups, index, player_count, combined_group)
    groups_with_score.each do |group|
      if length + group[0] == player_count


  end

  def set_rankings(groups_with_score, player_count)
    combined_groups = []
    groups_with_score.each do |group|
      if group[0].length == player_count
        combined_group = [group]
        combined_groups.push(combined_group)
      elsif group[0].length > 0
        
        recursive_check(groups_with_score, )
      end
    
    
    
    #combinations = (1..players.length).flat_map{|combo| groups.combination(combo).to_a}.select{|group| a= 0; group.each do |subgroup| a = a + subgroup.length end; a == players.length}
    #combinations = combinations.select{ |combo| combo.flatten.uniq.length == combo.flatten.length}
    #pp " combos #{combinations} #{players.length}"
    #top_games = Hash.new
    #combinations.each_with_index do |combo, i|
     # top_games[combo] = Hash.new
     # combo.each do |group|
     #   top_games[combo][group] = Hash.new

       # group_index = groups.find_index(group)
       # game_and_score = group_scores[group_index].max_by{|k,v| v}
       # top_games[combo][group][:game] = games.where(id: game_and_score[0]).first.name
       # top_games[combo][group][:score] = game_and_score[1]
       # pp top_games
        
        
        
        
     # end
    #end
    #top_games.map{|k,v| [k,v.values.map{|v| v[:score]}.sum(0),v.values.map{|v| v[:game]}] }.sort {|a,b| a[1] <=> b[1]}.last
  end

end
