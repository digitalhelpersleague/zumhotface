require 'resque/server'

Zumhotface::Application.routes.draw do

  mount Resque::Server.new, at: "/resque"
  mount ::API, at: '/api'

  get '/progress', to: proc { [404, {}, ["You should configure nginx-upload-progress to serve /progress route"]] }

  root 'pages#welcome'

  get '/welcome', to:'pages#welcome'
  get '/about', to:'pages#about'
  get '/privacy', to:'pages#privacy'

  get 'account', to:'account#index', as: :account, constraints: { format: /html|json/ }
  patch 'account', to:'account#update', as: :update_account, constraints: { format: /html|json/ }

  get '/request_invitation', to:'users#request_invitation'
  post '/request_invitation', to:'users#request_invitation'
  put '/users/generate_api_key', to:'users#generate_api_key'
  delete '/users/destroy_api_key', to:'users#destroy_api_key'

  get '/error_404', to: 'errors#error_404'
  get '/error_500', to: 'errors#error_500'

  devise_for :users

  resources :uploads, param: :sid, only: [:index, :new, :create, :destroy], constraints: { format: /html|json/ }

  resources :uploads, path: '', param: :sid, only: [:show], constraints: { format: /html|json/ } do
    member do
      get :download
      get :raw
    end
  end

  get '/*q', to: 'errors#error_404'
end
