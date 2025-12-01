Rails.application.routes.draw do
  # Page d'accueil
  root 'pages#home'
  
  # Pages statiques
  get 'securite', to: 'pages#securite'
  
  # Ressources principales
  resources :velos, only: [:index, :show]
  resources :itineraires, only: [:index, :show]
  resources :actualites, only: [:index, :show]
  resources :reservations, only: [:new, :create, :show]
  
  # Zone administrateur
  namespace :admin do
    # Authentification
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    # Dashboard
    root 'dashboard#index'
    
    # CRUD des ressources
    resources :velos
    resources :itineraires
    resources :actualites
    resources :reservations, only: [:index, :show, :destroy]
  end
end
