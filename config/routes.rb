Rails.application.routes.draw do
  resources :games, only: [:show, :create, :update]
end
