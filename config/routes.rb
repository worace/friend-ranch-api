Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show]
      get "/me" => "users#me"
      resources :sessions, only: [:create, :destroy]
    end
  end
end
