Rails.application.routes.draw do
  get 'notifications/index'
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
  # deviseに新しくルーティングを追加
  devise_scope :user do
    # テスト用で名前付きルート名のみ変更 9
    post '/users/sign_in', to: 'users/sessions#create', as: 'login'
    delete '/users/sign_out', to: 'users/sessions#destroy', as: 'logout'
    # ゲストログイン
    post '/users/guest_in', to: 'users/sessions#guest_in'
  end

  resources :users, only: [:index, :show, :destroy] do # 7, 10
    member do
      get :following, :followers
    end
  end

  resources :posts,         only: [:create, :destroy, :show]
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: :index
end
