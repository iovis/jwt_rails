Rails.application.routes.draw do
  get 'private/index'
  get 'public/index'
  post 'users/sign_in', to: 'sessions#create'
  post 'users/refresh_token', to: 'sessions#refresh_token'
  delete 'users/sign_out', to: 'sessions#destroy'

  devise_for :users
end
