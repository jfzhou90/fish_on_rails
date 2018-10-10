Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # static pages path
  resources :menu, only: [:index]
  resources :how_to, only: [:index]

  # sessions path
  resources :sessions, only: [:create]
  resource :session, only: [:destroy]

  # signup path
  resources :signup, only: [:index, :create]

  root 'sessions#new'
end