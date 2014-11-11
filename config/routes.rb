require 'resque/server'

Zumhotface::Application.routes.draw do

  mount Resque::Server.new, at: "/resque"
  mount ::API, at: '/api'

  get '/progress', to: proc { [404, {}, ["You should configure nginx-upload-progress to serve /progress route"]] }

  root 'pages#welcome'

  get '/welcome', to:'pages#welcome'
  get '/about', to:'pages#about'
  get '/privacy', to:'pages#privacy'

  get 'account', to:'account#index', as: :account
  patch 'account', to:'account#update', as: :update_account

  get '/request_invitation', to:'users#request_invitation'
  post '/request_invitation', to:'users#request_invitation'
  put '/users/generate_api_key', to:'users#generate_api_key'
  delete '/users/destroy_api_key', to:'users#destroy_api_key'

  devise_for :users

  resources :uploads, only: [:index, :create, :new]
  get '/:sid', to:'uploads#show', as: :upload
  get '/download/:sid', to:'uploads#download', as: :download_upload
  get '/raw/:sid', to:'uploads#download', as: :raw_upload, raw: true
  delete '/uploads/:sid', to:'uploads#destroy', as: :destroy_upload
end
