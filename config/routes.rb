Rails.application.routes.draw do
  devise_for :users
  root to: 'transaction#index'
end
