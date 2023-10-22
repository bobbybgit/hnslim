class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]
  before_action :filter_games, only: %i[table]
  require 'bgg'

  def user
  end

  def export_excel
    @collections = Collection.where.not(user_id: 7).map(&:game_id)
    @games = Game.where(id: @collections).where('weight > 1.6 or playing_time > 89')
    @users = User.all
    respond_to do |format|
      format.xlsx{
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=game_list.xlsx"
        
      }
    end
  end
    

   

  def bgg_update



    current_games = Game.all.by_user(current_user.id).map(&:bgg_id)
    bgg_collection_ids = []
    @error = nil
    @progress = 0

    def bgg_user_init(bgg_username)
      response = []
      begin 
        response = Bgg::Collection.find_by_username(current_user.bgg_username)
      rescue StandardError => e
        if e.message =~ /202/
          pp "202"
          sleep 3
          retry
        elsif e.message =~ /User does not exist/
          response = "Bgg user not found, please check your profile against your BGG account"
        else
          response = e.message.to_s
        end
      end
      pp response
      (response.present? && response.class != String) ? (response.boardgames & response.owned).sort{ |a,b| a.name <=> b.name }.map(&:id) : response
    end

    def import_games(bgg_collection_ids)
      response = []
      begin 
        pp BggApi.thing({id:"#{bgg_collection_ids[0]},#{bgg_collection_ids}",stats:1})["item"]
        response = BggApi.thing({id:"#{bgg_collection_ids[0]},#{bgg_collection_ids}",stats:1})["item"]
      rescue StandardError => e
        if e.message =~ /202/
          pp "202"
          sleep 3
          retry
        elsif e.message =~ /User does not exist/
          response = "Bgg Username not found, please check your profile against your BGG account"
        else
          response = e.message.to_s
        end
      end
      pp response
      return response
    end
    
    bgg_collection_ids = bgg_user_init(current_user.bgg_username) if current_user.bgg_username.present?

    pp bgg_collection_ids.class

    if bgg_collection_ids.class != String
      old_games = current_games - bgg_collection_ids
      bgg_collection_ids = bgg_collection_ids - current_games if current_games.present?
      bgg_collection_ids.count > 0 ? games_to_add = import_games(bgg_collection_ids) : @error = "No Games Found"
      
      if games_to_add.present? && games_to_add.class != String
        games_to_add.each_with_index do |game, i|
          if (!Game.find_by(bgg_id: game["id"]).present?)
            game_to_add = Game.create(
              bgg_id: game["id"],
              min_players: game["minplayers"][0]["value"],
              max_players: game["maxplayers"][0]["value"],
              min_rec_players: PollCheck.players(game).min,
              max_rec_players: PollCheck.players(game).max,
              image: game["image"],
              description: game["description"],
              name: game["name"][0]["value"],
              year: game["yearpublished"][0]["value"],
              playing_time: game["playingtime"][0]["value"],
              weight: game["statistics"][0]["ratings"][0]["averageweight"][0]["value"]         )
            else
              game_to_add = Game.find_by(bgg_id: game["id"])
          end
          Collection.create(
            user_id: current_user.id,
            game_id: game_to_add.id
          )
        end
      elsif games_to_add.class == String
        @error = games_to_add
      end

      if old_games.present?
        remove_games = Collection.where(game_id: Game.where(bgg_id: old_games).pluck(:id), user_id: current_user.id)
        remove_games.destroy_all
      end
    else
      @error = bgg_collection_ids
    end

    redirect_to games_table_path(id: current_user.id, error: @error), data:{turbo_frame: :games_table}
  

  end

  # GET /games or /games.json
  def index
    @groups = Group.all
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def table
    @ratings = current_user.ratings.map { |r| [r.game_id, r.rating] }.to_h
    @error = params[:error] if params[:error].present?
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:name, :min_players, :max_players, :min_rec_players, :max_rec_players, :weight, :image, :bgg_id, :description)
    end

    def filter_games
      pp params[:group]
      pp params[:id]
      (!params[:group].present? || params[:group] == "-1") ? group = 0 : group = params[:group]
      (!params[:id].present? || params[:id] == "-1") ? id = 0 : id = params[:id]
      filter = params[:filter]
      pp group
      pp id
      pp filter

      params[:column] = "name" if !params[:column].present?
      @error = nil
      case params[:column].downcase
      when "year"
        @games = search_games(group,id,filter).order(:year)
      when "weight"
        @games = search_games(group,id,filter).order(:weight)
      when "rating"
        @games = search_games(group,id,filter).joins(:ratings).where(ratings:{user_id: current_user.id}).order(:rating) + (search_games(group,id,filter) - search_games(group,id,filter).joins(:ratings).where(ratings:{user_id: current_user.id}))
      else
        @games = search_games(group,id,filter).order(:name)
        pp params[:column]
      end
      @games = @games.reverse if params[:direction] == "up" 
      
    end
  
    def search_games(group,id,filter)

      pp group
      pp id
      
      if (!Group.all.first.present?) || (group == 0)
        id != 0 ? @games = Game.joins(:collections).where(collections:{user_id: id}) : @games = Game.all 
      else
        @group = Group.find_by_id(group)
        id !=0 ? @games = Game.joins(:collections).where(collections:{user_id: id}) : @games = Game.joins(:collections).where(collections:{user_id: @group.users.pluck(:id)})
      end
      if filter.present?
        @games = @games.games_search(filter)
      end 
      return @games
    end
    

end
