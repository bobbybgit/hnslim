json.extract! game, :id, :name, :min_players, :max_players, :min_rec_players, :max_rec_players, :weight, :image, :bgg_id, :description, :created_at, :updated_at
json.url game_url(game, format: :json)
