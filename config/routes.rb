Rails.application.routes.draw do
  devise_for :users
  root to: 'transaction#index'
  resources :transaction
end
