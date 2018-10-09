Rails.application.routes.draw do


  get 'leaderboard/index'
  get 'how_to/index'
  get 'menu/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # static pages path
  resource :menu, only: [:index]
  resource :how_to, only: [:index]

  # sessions path
  resource :sessions, only: [:new, :create, :destroy]

  # static menu path

  root 'menu#index'
end