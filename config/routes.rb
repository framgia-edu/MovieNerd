Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/price", to: "static_pages#price"
    get "/about", to: "static_pages#about"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "sessions/new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    namespace :admin do
      get "/", to: "dashboards#index"
      resources :movies
      resources :screenings, only: [:index, :new, :create, :destroy]
      resources :users, only: [:index, :show, :update]
      resource :block_users, only: [:create, :destroy]
      resource :privilege, only: [:create, :destroy]
      resources :rooms, only: [:new, :create, :show]
    end
    resources :movies, only: [:searchs, :screenings] do
      collection do
        resources :searchs, only: [:index, :create]
      end
      member do
        resources :screenings, only: [:index]
      end
    end
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :rooms, only: [:show]
    resources :movies, only: [:show]
    resources :schedules, only: [:index]
  end
end
