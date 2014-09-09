require 'resque/server'

Zumhotface::Application.routes.draw do

  mount Resque::Server.new, at: "/resque"
  mount ::API, at: '/api'

  get '/progress', to: proc { [404, {}, ["You should configure nginx-upload-progress to serve /progress route"]] }

  root 'pages#welcome'

  get '/welcome' => 'pages#welcome'
  get '/about' => 'pages#about'
  get '/privacy' => 'pages#privacy'

  get 'account' => 'account#index', as: :account
  patch 'account' => 'account#update', as: :update_account

  get '/request_invitation' => 'users#request_invitation'
  post '/request_invitation' => 'users#request_invitation'
  put '/users/generate_api_key' => 'users#generate_api_key'
  delete '/users/destroy_api_key' => 'users#destroy_api_key'

  devise_for :users

  #resources :keys, only: [:index, :create, :show, :destroy]

  resources :uploads, only: [:index, :create, :new]
  get '/:sid' => 'uploads#show', as: :upload
  get '/download/:sid' => 'uploads#download', as: :download_upload
  delete '/uploads/:sid' => 'uploads#destroy'

end
