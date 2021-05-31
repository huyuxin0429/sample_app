Rails.application.routes.draw do
  get 'm_sessions/new'
  get 'merchants/new'

  get 'sessions/new'

  get 'users/new'
  get 'home' => 'static_pages#home'
  #get 'static_pages/home'
  get 'help' => 'static_pages#help'
  #get 'static_pages/help'
  get 'about' => 'static_pages#about'
  #get 'static_pages/about'
  get 'contact' => 'static_pages#contact'
  #get 'static_pages/contact'
  get 'signup' => 'users#new'

  get 'msignup' => 'merchants#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'mlogin' => 'm_sessions#new'
  post 'mlogin' => 'm_sessions#create'
  delete 'mlogout' => 'm_sessions#destroy'

  resources :users
  resources :merchants
  resources :account_activations, only: [:edit]
end
