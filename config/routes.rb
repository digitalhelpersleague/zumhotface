Zumhotface::Application.routes.draw do

  root 'pages#welcome'

  get '/welcome' => 'pages#welcome'
  get '/about' => 'pages#about'
  get '/privacy' => 'pages#privacy'

  devise_for :users

  #resources :keys, only: [:index, :create, :show, :destroy]

  resources :uploads, only: [:index, :create, :new]
  delete '/uploads/:sid' => 'uploads#destroy'
  get '/:sid' => 'uploads#show', as: :upload
  get '/download/:sid' => 'uploads#download', as: :download_upload

end
