Rails.application.routes.draw do
  resources :order_maps
  namespace :api do
    namespace :v1 do
      get 'health/index'
    end
  end
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
      mount ActionCable.server, at: '/cable'
      resources :account_activations,     only: [:edit]
      post 'login' => 'sessions#create'
      get 'auto_login' => 'sessions#auto_login'
      delete 'logout' => 'sessions#destroy'
      # resources :sessions, only: [:create, :]
      # post 'customers' => 'users#createCustomer'
      # get 'customers' => 'users#indexCustomer'
      # get 'customers/:id' => 'users#showCustomer'
      # get 'customers/:user_id/addresses' => 'addresses#index'
      # post 'customers/:user_id/addresses' => 'addresses#create'
      # get 'customers/:user_id/addresses/:id' => 'addresses#show'
      # patch 'customers/:id' => 'users#update'
      # patch 'customers/:user_id/addresses/:id' => 'addresses#update'
      # delete 'customers/:id' => 'users#destroy'
      

      # post 'merchants' => 'users#createMerchant'
      # get 'merchants' => 'users#indexMerchant'
      get 'merchants/addresses' => 'merchants#showAllMerchantAddresses'
      # get 'merchants/:id' => 'users#showMerchant'
      # get 'merchants/:user_id/addresses' => 'addresses#index'
      # post 'merchants/:user_id/addresses' => 'addresses#create'
      # get 'merchants/:user_id/addresses/:id' => 'addresses#show'
      # patch 'merchants/:id' => 'users#update'
      # patch 'merchants/:user_id/addresses/:id' => 'addresses#update'
      # delete 'merchants/:id' => 'users#destroy'
      post 'newOrder' => 'orders#create'

      resources :merchants, only: [ :index, :create, :show, :update, :destroy] do
        resources :addresses, only: [:index, :create, :show, :update, :destroy]
        resources :products, only: [:index, :create, :show, :update, :destroy] do
          resources :orders, only: [:index, :show, :destroy] do
            resources :order_entries, only: [:index, :show, :update]
          end
        end
        resources :orders, only: [:index, :show, :destroy] do
          resources :order_entries, only: [:index, :show, :update]
        end
      end

      resources :customers, only: [ :create, :index, :show, :update, :destroy] do
        resources :addresses, only: [:index, :create, :show, :update, :destroy]
        resources :orders, only: [:index, :show, :destroy] do
          resources :order_entries, only: [:index, :show, :update]
        end
      end
      # resources :users, only: [ :index, :create, :show, :update, :destroy] do
      #   post :activate, on: :collection
      #   resources :addresses, only: [:index, :create, :show, :update, :destroy]
      #   resources :followers, only: [:index, :destroy]
      #   resources :followings, only: [:index, :destroy] do
      #     post :create, on: :member
      #   end
      #   resource :feed, only: [:show]
      # end
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
