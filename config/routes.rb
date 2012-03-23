TWAmazon::Application.routes.draw do

  match '/' => 'silent_auctions#new'

  resources :silent_auctions, :only => [:create, :new]

  devise_for :users, :controllers => { :omniauth_callbacks => "sessions"}
end
