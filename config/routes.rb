TWAmazon::Application.routes.draw do

  match '/' => 'silent_auctions#index'

  resources :silent_auctions, :only => [:create, :new, :index]

  devise_for :users, :controllers => { :omniauth_callbacks => "sessions"}
end
