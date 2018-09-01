Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :games, only: [:show, :create] do
        post "/shots", to: "games/shots#create"
        post "/ships", to: "games/ships#create"
      end
    end
  end
  root 'welcome#index'
  get '/register', to: 'register#index', as: 'register'
  post '/register', to: 'register#create'
  get '/dashboard', to: 'dashboard#index'

  get '/registration_notification', to: 'registration_notification#create'
  get '/activation/:activation_token', to: 'activation#update', as: 'activation'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
