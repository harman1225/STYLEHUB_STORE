Rails.application.routes.draw do
  get "pages/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  #  ADD THIS PART
  root "products#index"
  resources :products, only: [:index, :show]
# Cart
  resource :cart, only: [:show] do
  post "add/:product_id", to: "cart#add", as: :add_to
  patch "update/:product_id", to: "cart#update", as: :update
  delete "remove/:product_id", to: "cart#remove", as: :remove
end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/pages/:title", to: "pages#show", as: :page

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
