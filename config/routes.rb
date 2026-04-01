Rails.application.routes.draw do
  get "carts/show"
  devise_for :users
  get "pages/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :orders, only: [:index, :show, :create]
  patch "/orders/:id/ship", to: "orders#ship", as: "ship_order"

  root "products#index"
  resources :products, only: [:index, :show]

  resource :cart, only: [:show], controller: "carts" do
    post "add/:product_id", to: "carts#add", as: :add_to
    patch "update/:product_id", to: "carts#update", as: :update
    delete "remove/:product_id", to: "carts#remove", as: :remove
  end

  get "/checkout", to: "checkout#show", as: :checkout
  post "/checkout", to: "checkout#create", as: :place_order

  get "up" => "rails/health#show", as: :rails_health_check
  get "/pages/:title", to: "pages#show", as: :page
  get "orders/:id/success", to: "orders#success", as: :order_success
end