class CartController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @products = Product.find(@cart.keys)
  end

  def add
    session[:cart] ||= {}
    product_id = params[:product_id].to_s

    if session[:cart][product_id]
      session[:cart][product_id] += 1
    else
      session[:cart][product_id] = 1
    end

    redirect_to cart_path
  end

  def update
    product_id = params[:product_id].to_s
    session[:cart][product_id] = params[:quantity].to_i
    redirect_to cart_path
  end

  def remove
    session[:cart].delete(params[:product_id].to_s)
    redirect_to cart_path
  end
end