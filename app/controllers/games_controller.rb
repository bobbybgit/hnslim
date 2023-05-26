class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]
  require 'bgg'

  def user_games
    @games = Game.all.by_user(params[:id])
  end

  def bgg_update

    current_games = Game.all.by_user(current_user.id).map(&:bgg_id)
    bgg_collection_ids = []
    @error = nil

    def bgg_user_init
      if (current_user.bgg_username.present?)
        collection = Bgg::Collection.find_by_username(current_user.bgg_username)
        if collection.present?
          bgg_collection_ids = (collection.boardgames & collection.owned).sort{ |a,b| a.name <=> b.name }.map(&:id)
        else
          @error = "BGG User does not exist"
          return
        end
      else
        @error = "BGG User does not exist"
        return
      end
    end
    bgg_user_init
    bgg_collection_ids = bgg_collection_ids - current_games
    bgg_collection_ids.count > 0 ? games_to_add = BggApi.thing({id:"#{@game_ids[0]},#{@game_ids}"})["item"] : @error = "No Games Found"

    if games_to_add.present?
      games_to_add.each do |game|
        if (!Game.find_by(bgg_id: game.id).present?)
          game_to_add = Game.create(
            bgg_id: game["id"],
            min_player_count: game["minplayers"][0]["value"],
            max_player_count: game["maxplayers"][0]["value"],
            min_rec_player_count: PollCheck.players(game).min,
            max_rec_player_count: PollCheck.players(game).max,
            image: game["image"],
            description: game["description"],
            name: game["name"][0]["value"]
          )
        end
        Collection.create(
          user_id: current_user.id,
          game_id: game_to_add.id
        )
      end
    end

    redirect_to user_games_path(current_user.id)
  end

  # GET /games or /games.json
  def index
    @games = Game.all
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
end
