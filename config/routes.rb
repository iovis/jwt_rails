Rails.application.routes.draw do
  get 'private/index'
  get 'public/index'
  post 'users/sign_in', to: 'sessions#create'

  devise_for :users
end
