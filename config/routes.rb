Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resources :products, :except => [:destroy]
  resources :products, :path => '/', :only => [:destroy]
    
  resource :refresh_data
end