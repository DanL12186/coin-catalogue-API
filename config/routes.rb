Rails.application.routes.draw do
  root 'application#home'

  get '/coins' => 'coins#filter_coins'

  get '/coin' => 'coins#show'
  
  # get '/coins/:denomination' => 'coins#denomination'

  # #doesn't work. not nested, maybe?
  # get '/coins/:denomination/:year-and-mintmark' => 'coins#show'
end
