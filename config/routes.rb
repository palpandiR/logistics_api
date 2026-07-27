Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get :health, to: "health#index"
      resources :customers, only: [:show, :create]
      post "login", to:"authentication#login"
      get "test_error", to: "customers#test_error"
    end

    namespace :v2 do
      get :health, to: "health#index"
    end
  end
end
