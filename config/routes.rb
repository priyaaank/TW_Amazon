TWAmazon::Application.routes.draw do
  resources :email_notifications
  resources :categories

  match '/landing',    to: 'home#landing'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

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

  resources :bids, :only => [:create, :new, :update] do
    member do
      put 'withdraw'
      post 'update_amount'
      put 'delete'
    end
  end

  resources :faqs, :only  => [:index]

  resources :users, :only => [:show] do
    member do
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
