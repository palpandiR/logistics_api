Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get :health, to: "health#index"
      resources :customers, only: [:show]
    end

    namespace :v2 do
      get :health, to: "health#index"
    end
  end
end
