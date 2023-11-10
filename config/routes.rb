Rails.application.routes.draw do
  devise_for :users
  root to: 'transactions#index'
  get 'transactions/import', to: 'transactions#import_form', as: 'transaction_import_form'
  post 'transactions/import', to: 'transactions#import', as: 'transaction_import'
  get 'transactions/export', to: 'transactions#export', as: 'transaction_export'
  resources :transactions
end
