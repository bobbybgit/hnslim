Rails.application.routes.draw do
  get "users/index", to: "users#index", as: "users"
  get "games/update", to: "games#bgg_update", as: "update_games"
  resources :games
  devise_for :users
  get "pages/dash", to: "pages#dash", as: "dash"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#dash"
end
