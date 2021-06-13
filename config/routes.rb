Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'sesssions/new'
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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sessions, only: [:create, :show]
      resources :users, only: [:index, :create, :show, :update, :destroy] do
        post :activate, on: :collection
        resources :addresses, only: [:index, :create, :show, :update, :destroy]
        resources :followers, only: [:index, :destroy]
        resources :followings, only: [:index, :destroy] do
          post :create, on: :member
        end
        resource :feed, only: [:show]
      end
      resources :microposts, only: [:index, :create, :show, :update, :destroy]
    end
  end
      
    

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations,     only: [:edit]
  resources :password_resets,         only: [:new, :create, :edit, :update] 
  resources :microposts,              only: [:create, :destroy]
  resources :relationships,           only: [:create, :destroy]
end
