Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

resources :movies do
  member do
    post :collect
    post :cancel
  end
  resources :reviews
end
root 'movies#index'
end
