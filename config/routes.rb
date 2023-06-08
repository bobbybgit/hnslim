Rails.application.routes.draw do
  get "users/index", to: "users#index", as: "users"
  get "games/update", to: "games#bgg_update", as: "update_games"
  get "games/table", to: "games#table", as: "games_table"
  get "games/user/:id", to: "games#user", as: "user_games"
  post "ratings", to: "ratings#new", as: "new_rating"
  get "ratings/confirm", to: "ratings#confirm", as: "confirm_rating"
  resources :games
  devise_for :users
  get "pages/dash_content", to: "pages#dash_content", as: "dash_content"
  get "pages/dash", to: "pages#dash", as: "dash"
  delete "collections/:id", to: "collections#delete", as: "destroy_collection"
  get "play/new", to: "play#new", as: "new_play"
  get "play/player_select", to: "play#player_select", as: "player_select"
  get "play/results", to: "play#results", as: "play_results"
  get "play/options", to: "play#options", as: "play_options"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#dash"
end
