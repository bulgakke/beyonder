Rails.application.routes.draw do
  root "users#me"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  resource :session
  resources :passwords, param: :token

  get "me" => "users#me"

  resources :users, only: %i[show create edit update], param: :username do
    resources :posts
  end

  scope "/games" do
    namespace :tic_tac_toe do
      resources :lobbies, only: [:index, :show, :create] do
        member do
          post :join
          post :leave
          post :start
        end
      end

      resources :games, only: [:show], path: "" do
        post :make_move, on: :member
      end
    end
  end
end
