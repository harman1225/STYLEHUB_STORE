# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'products#index'

  resources :products, only: %i[index show]
  resources :pages, only: [:show]

  #  Orders (keep only one)
  resources :orders, only: %i[index show create]
  patch '/orders/:id/ship', to: 'orders#ship', as: 'ship_order'
  get 'orders/:id/success', to: 'orders#success', as: :order_success

  #  Cart (your existing structure, just fixed)
  resource :cart, only: [:show], controller: 'carts' do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    patch 'update/:product_id', to: 'carts#update', as: :update
    delete 'remove/:product_id', to: 'carts#remove', as: :remove
  end

  # Checkout
  get '/checkout', to: 'checkout#show', as: :checkout
  post '/checkout', to: 'checkout#create', as: :place_order
  get '/checkout/success', to: 'checkout#success', as: :success_checkout

  # Static pages
  get '/about', to: 'pages#show', defaults: { id: 1 }
  get '/contact', to: 'pages#show', defaults: { id: 2 }

  get 'up' => 'rails/health#show', as: :rails_health_check
end
