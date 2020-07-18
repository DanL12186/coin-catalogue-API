Rails.application.routes.draw do
  get '/coins' => 'coins#filter_coins'
  get '/coin' => 'coins#show'

  get '/series' => 'series#filter_series'

  get '/prices' => 'gold_and_silver_prices#prices'
end