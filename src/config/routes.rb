Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # deviseに新しくルーティングを追加したい場合
  devise_scope :user do
    # テスト用に名前付きルート名のみ変更 9
    post '/users/sign_in', to: 'users/sessions#create', as: 'login'
    delete '/users/sign_out', to: 'users/sessions#destroy', as: 'logout'
  end

  resources :users, :only => [:show] # 7
end
