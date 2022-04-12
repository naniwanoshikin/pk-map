Rails.application.routes.draw do
  get 'bads/create'
  get 'bads/destroy'
  root 'home_pages#home'
  get  '/help',    to: 'home_pages#help'
  get  '/about',   to: 'home_pages#about'
  get  '/contact', to: 'home_pages#contact'

  # ajax 投稿ワード検索
  # namespace :home_pages do
  #   resources :homes, only: :home, defaults: { format: :json }
  # end
  # resources :home_pages

  # コントローラのルーティングを変更: devise → users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  # deviseにルーティングを追加
  devise_scope :user do
    # テスト用で名前付きルート名のみ変更 9
    post '/users/sign_in', to: 'users/sessions#create', as: 'login'
    delete '/users/sign_out', to: 'users/sessions#destroy', as: 'logout'
    # ゲストログイン home(V) to Sesssions(C)
    post '/users/guest1', to: 'users/sessions#guest_in1'
    post '/users/guest2', to: 'users/sessions#guest_in2'
    post '/users/guest3', to: 'users/sessions#guest_in3'
  end

  resources :users, only: [:index, :show, :destroy] do
    member do
      get :following, :followers
      get :show_reviews
    end
  end

  resources :posts,  only: [:create, :destroy, :show, :new] do
    resource :reviews,  only: [:create, :destroy]
  end

  resources :reviews,  only: [:show] do
    member do
      get :good_users
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :goods,         only: [:create, :destroy]
  resources :bads,          only: [:create, :destroy]
  resources :notifications, only: :index
end
