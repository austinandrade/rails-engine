Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "merchants/find", to: 'search#find_merchant'
      get "items/find_all", to: 'search#find_items'
      get "revenue/merchants", to: 'calculations#top_merchants'
      resources :merchants, only: [:index, :show]
      get "merchants/:id/items", to: 'merchant_items#index'
      resources :items
      get "items/:id/merchant", to: 'item_merchant#show'
    end
  end
end
