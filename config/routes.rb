TWAmazon::Application.routes.draw do
  resources :silent_auctions

  devise_for :users, :controllers => { :omniauth_callbacks => "sessions"}
end
