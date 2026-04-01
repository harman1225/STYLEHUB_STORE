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
  params[:quantities].each do |product_id, qty|
    if qty.to_i > 0
      session[:cart][product_id] = qty.to_i
    else
      session[:cart].delete(product_id)
    end
  end

  redirect_to cart_path
end

def remove
  session[:cart].delete(params[:id])
  redirect_to cart_path
end