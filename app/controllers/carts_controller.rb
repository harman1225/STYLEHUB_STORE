class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
  end

  def add
    session[:cart] ||= {}
    product_id = params[:product_id].to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    redirect_to cart_path, notice: "Product added to cart."
  end

  def update
    session[:cart] ||= {}
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
    else
      session[:cart].delete(product_id)
    end

    redirect_to cart_path, notice: "Cart updated."
  end

  def remove
    session[:cart] ||= {}
    session[:cart].delete(params[:product_id].to_s)

    redirect_to cart_path, notice: "Item removed from cart."
  end
end
