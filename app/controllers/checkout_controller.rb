class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = session[:cart] || {}

    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @products = Product.where(id: @cart.keys)

    @subtotal = @products.sum do |product|
      product.price * @cart[product.id.to_s].to_i
    end

    province = current_user.province
    gst_rate = province&.gst.to_f
    pst_rate = province&.pst.to_f
    hst_rate = province&.hst.to_f

    @gst_amount = @subtotal * gst_rate
    @pst_amount = @subtotal * pst_rate
    @hst_amount = @subtotal * hst_rate
    @total = @subtotal + @gst_amount + @pst_amount + @hst_amount
  end

  def create
    cart = session[:cart] || {}

    if cart.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    products = Product.where(id: cart.keys)

    subtotal = products.sum do |product|
      product.price * cart[product.id.to_s].to_i
    end

    province = current_user.province
    gst_rate = province&.gst.to_f
    pst_rate = province&.pst.to_f
    hst_rate = province&.hst.to_f

    gst = subtotal * (province.gst / 100.0)
    pst = subtotal * (province.pst / 100.0)
    hst = subtotal * (province.hst / 100.0)
    total = subtotal + gst + pst + hst

    order = current_user.orders.create!(
  status: "new",
  total: total,
  gst: gst,
  pst: pst,
  hst: hst
)

    products.each do |product|
      quantity = cart[product.id.to_s].to_i

      order.order_items.create!(
        product: product,
        quantity: quantity,
        price: product.price
      )
    end

    session[:cart] = {}
    redirect_to order_success_path(order), notice: "Order placed successfully."
  end
end