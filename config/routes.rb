Rails.application.routes.draw do
  get 'private/index'
  get 'public/index'
  post 'users/sign_in', to: 'sessions#create'
  post 'users/refresh_token', to: 'sessions#refresh_token'

  devise_for :users
end
