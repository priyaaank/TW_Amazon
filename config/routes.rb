TWAmazon::Application.routes.draw do


  resources :email_notifications


  resources :categories

  match '/landing',    to: 'home#landing'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config


  # define an index or home path to redirect if a user already login
  match 'silent_auctions', :to => 'SilentAuctions#index', :as => :index, :via => :get

  # silent auctions paths
  resources :silent_auctions, :only => [:index, :create, :new, :destroy, :edit, :update]
  resources :silent_auctions do
    member do
      put 'close'
      post 'confirm_delete'
    end

    collection do
      get 'closed'
      get 'expired'
      get 'future'
      get 'normal_auctions'
      get 'sales'
    end
    resources :auction_messages
    resources :photos, :only => [:index, :create, :destroy]
  end


  # bid paths
  resources :bids, :only => [:create, :new, :update]
  resources :bids do
    member do
      put 'withdraw'
      post 'update_amount'
      put 'delete'
    end
  end

  # user paths
  resources :users, :only => [:show]
  resources :users do
    member do
      get :faq_page
      get :notification
      get :list_my_items
      get :list_my_normal_auctions
      get :list_my_sales
      get :new_region
      post :update_region
    end
  end

  root :to => 'home#login'
  devise_for :users, :skip => [:sessions], :controllers => { :omniauth_callbacks => "sessions"}
  devise_scope :user do
    get '/login', :to => "sessions#new", :as => :new_user_session
    get '/logout_cas', :to => 'sessions#destroy_cas', :as => :destroy_user_session
    match "/cas/logout" => redirect('http://cas.thoughtworks.com/cas/logout'), :as => :cas_logout
  end

  #Routes to dummy session controller for dev and test environments
  unless Rails.env.production?
    devise_for :users,
      :controllers => { :sessions => "dummy_sessions" },
      :path_names => { :sign_in => '/test_users/login', :sign_out => 'test-users/logout'},
      :except => [:new_user_session, :destroy_user_session]

    devise_scope :user do
      get '/test-users/login', :to => 'dummy_sessions#new', :as => :new_user_session
      get '/test-users/logout', :to => 'dummy_sessions#destroy', :as => :destroy_user_session
    end
  end
end
