Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#index'
  resources :merchants
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  # delete "/items/:id", to: "items#destroy"

  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:destroy, :edit, :update]
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  resources :cart, only: [:update], as: 'cart_update'

  get "/profile/orders/new", to: "user_orders#new"
  post "/profile/orders", to: "user_orders#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"

  get "/register", to: "register#new"
  post "/register", to: "register#create"

  get "/profile", to: "profiles#show"
  get "/profile/orders", to: 'user_orders#index'

  get "/profile/orders/:id", to: 'user_orders#show'

  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/edit_password", to: "users#password"
  patch '/profile/edit_password', to: "users#update_password"

  patch "/profile/orders/:order_id/cancel", to: "user_orders#cancel"

  namespace :merchant do
    put "items/:id", to: "items#update_active"
    patch "items/:id", to: "items#update"
    resources :items, only: [:index, :edit, :new, :create, :destroy]
    get '/', to: "dashboard#show"
    # get "/items", to: "items#index"
    # get 'items/:id/edit', to: "items#edit"
    # get "/items/new", to: "items#new"
    # post "/items", to: "items#create"
    patch '/:order_id/:item_id', to: "orders#update"
    get "/orders/:id", to: "orders#show"
    # resources :items, only: [:destroy]
    resources :discounts, only: [:index, :show, :create, :new, :edit, :destroy, :update]
  end

  namespace :admin do
    get '/', to: "dashboard#show"
    resources :users, only: [:index, :show]
    # get "/users", to: "users#index"
    # get '/users/:id', to: 'users#show'
    patch '/:id', to: 'merchants#update'

    # get '/merchants', to: "merchants#index"
    # get '/merchants/new', to: 'merchants#new'
    # post '/merchants/', to: 'merchants#create'
    patch '/merchants/:id', to: 'merchants#status'
    # get '/merchants/:id', to: 'merchants#show'
    get '/merchants/:id/items', to: 'merchant_items#index'
    # get '/merchants/:id/edit', to: 'merchants#edit'
    put '/merchants/:id/', to: 'merchants#update_merchant'
    # delete '/merchants/:id', to: 'merchants#destroy'
    get '/merchants/:id/merchant_items/add-item', to: 'merchant_items#new'
    # post '/merchants/:id/items', to: 'merchant_items#create'
    # get '/merchants/:merchant_id/items/:id/edit', to: 'merchant_items#edit'
    put '/merchants/:merchant_id/merchant_items/:id', to: 'merchant_items#update'
    # delete '/merchants/:merchant_id/items/:id', to: 'merchant_items#destroy'
    patch '/merchants/:merchant_id/merchant_items/:id', to: 'merchant_items#update_active'
    # get '/merchants/:merchant_id/orders/:id', to: 'merchant_orders#show'
    patch '/merchants/:merchant_id/merchant_orders/:order_id/:item_id', to: 'merchant_orders#update'
    resources :merchants, only: [:index, :new, :create, :destroy, :show, :edit] do
      resources :merchant_orders, only: [:show]
      resources :merchant_items, except: [:show, :update]
    end
  end

  get "/logout", to: "sessions#logout"
end
