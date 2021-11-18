Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#home'
  namespace :api, defaults: { format: 'json' }do
    namespace :v1 do
      resources :videos, only: :create
    end
  end
end
