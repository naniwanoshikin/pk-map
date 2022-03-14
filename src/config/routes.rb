Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

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
      get :show_comments
    end
  end

  resources :posts,         only: [:create, :destroy, :show, :new] do
    resource :comments,     only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes,         only: [:create, :destroy]
  resources :notifications, only: :index
end
