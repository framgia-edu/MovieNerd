Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users
    root "static_pages#home"
    get "/not_sell", to: "static_pages#not_sell"
    get "/price", to: "static_pages#price"
    get "/about", to: "static_pages#about"
    resources :users do
      resources :orders, only: [:show, :index]
    end
    namespace :admin do
      get "/", to: "dashboards#index"
      resources :movies
      resources :searchs, only: [:index, :create]
      resources :screenings, only: [:index, :new, :create, :destroy]
      resources :users, only: [:index, :show, :update]
      resource :block_users, only: [:create, :destroy]
      resource :privilege, only: [:create, :destroy]
      resources :rooms, only: [:index, :new, :create, :show, :edit, :update]
    end
    resources :movies, only: [:searchs, :screenings] do
      member do
        resources :screenings, only: [:index]
      end
    end
    resources :searchs, only: [:index, :create]
    resources :account_activations, only: [:edit]
    # resources :password_resets, only: [:new, :create, :edit, :update]
    resources :rooms, only: [:show]
    resources :movies, only: [:show]
    resources :schedules, only: [:index]
    resources :showings, only: [:index]
    resources :comings, only: [:index]
    resources :orders, only: [:create]
    resources :accepts, only: [:index]
    get "/fails", to: "orders#destroy"
  end
end
