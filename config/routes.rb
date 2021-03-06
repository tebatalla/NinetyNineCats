Rails.application.routes.draw do
  root 'sessions#new'
  resources :cats
  resources :cat_rental_requests, only: [:new, :edit, :create, :update, :destroy] do
    member do
      post 'approve'
      post 'deny'
    end
  end
  resources :users, only: [:new, :create]
  resource :user, only: [:show]
  resource :session, only: [:new, :create, :destroy]
end
