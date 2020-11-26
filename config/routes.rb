Rails.application.routes.draw do
  get '/coins' => 'coins#filter_coins'
  get '/coin' => 'coins#show'

  get '/series' => 'series#filter_series'

  get '/prices' => 'gold_and_silver_prices#prices'
  post '/login' =>  'sessions#login'
  post '/signup' => 'users#create'

  resources :wishlists, only: [:index, :show, :update, :create]
  post '/wishlists/:id/add_coin', to: 'wishlists#add_coin'
end