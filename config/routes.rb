TWAmazon::Application.routes.draw do

  root :to => 'home#login'

  # define an index or home path to redirect if a user already login
  match 'silent_auctions', :to => 'SilentAuctions#index', :as => :index

  # silent auctions paths
  resources :silent_auctions, :only => [:index, :create, :new, :destroy]
  resources :silent_auctions do
    member do
      put 'close'
      post 'confirm_delete'
    end

    collection do
      get 'closed'
      get 'expired'
    end
  end


  # bid paths
  resources :bids, :only => [:create, :new]
  resources :bids do
    member do
      put 'withdraw'
    end
  end

  # user paths
  resources :users, :only => [:show]

  # Paths generated by devise for user authentication:
  # user_omniauth_authorize_path(provider)
  # user_omniauth_callback_path(provider)
  devise_for :users, :skip => [:sessions], :controllers => { :omniauth_callbacks => "sessions"}

  devise_scope :user do
    get '/login', :to => "sessions#new", :as => :new_user_session
    get '/logout_cas', :to => 'sessions#destroy_cas', :as => :destroy_cas_user_session
    match "/cas/logout" => redirect('http://cas.thoughtworks.com/cas/logout'), :as => :cas_logout
  end

  # for dummy user accounts
  if Rails.application.config.test_mode
    devise_for :users,
               :controllers => { :sessions => "dummy_sessions" },
               :path_names => { :sign_in => 'login', :sign_out => 'logout'}

    devise_scope :user do
      get '/test-users/login', :to => 'dummy_sessions#new', :as => :new_dummy_session
      get '/test-users/logout', :to => 'dummy_sessions#destroy', :as => :destroy_user_session
    end
  end

end
