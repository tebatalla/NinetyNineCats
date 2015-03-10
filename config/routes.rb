Rails.application.routes.draw do
  resources :cats do
  end
  resources :cat_rental_requests, only: [:new, :edit, :create, :update, :destroy]
end
