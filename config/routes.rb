Rails.application.routes.draw do
  root 'application#home'

  get '/coins' => 'coins#filter_coins'
  get '/coin' => 'coins#show'

  get '/series' => 'series#filter_series'

  get '/prices' => 'gold_and_silver_prices#prices'
  get '/update_prices' => 'gold_and_silver_prices#update_prices'
end