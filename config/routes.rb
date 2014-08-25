require 'resque/server'

Zumhotface::Application.routes.draw do

  get 'account' => 'account#index', as: :account
  patch 'account' => 'account#update', as: :update_account

  mount Resque::Server.new, at: "/resque"

  root 'pages#welcome'

  get '/welcome' => 'pages#welcome'
  get '/about' => 'pages#about'
  get '/privacy' => 'pages#privacy'

  get '/request_invitation' => 'users#request_invitation'
  post '/request_invitation' => 'users#request_invitation'

  devise_for :users

  #resources :keys, only: [:index, :create, :show, :destroy]

  resources :uploads, only: [:index, :create, :new]
  get '/:sid' => 'uploads#show', as: :upload
  get '/download/:sid' => 'uploads#download', as: :download_upload
  delete '/uploads/:sid' => 'uploads#destroy'

end
