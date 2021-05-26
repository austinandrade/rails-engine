Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      get "merchants/:id/items", to: 'merchant_items#index'
      resources :items
      get "items/:id/merchant", to: 'item_merchant#show'
    end
  end
end
