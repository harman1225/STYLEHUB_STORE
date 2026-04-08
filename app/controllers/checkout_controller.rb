class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def success
    order = nil

    if params[:order_id].present?
      order = current_user.orders.find_by(id: params[:order_id])
    end

    if order.nil? && params[:session_id].present?
      order = current_user.orders.find_by(stripe_payment_id: params[:session_id])
    end

    if order.nil?
      redirect_to orders_path, alert: "Order not found."
      return
    end

    order.update(
      paid: true,
      payment_id: order.stripe_payment_id || "TEST#{SecureRandom.hex(5)}",
      status: "paid"
    )

    session[:cart] = {}

    redirect_to orders_path, notice: "Payment successful!"
  end

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

    @gst_amount = @subtotal * (gst_rate / 100.0)
    @pst_amount = @subtotal * (pst_rate / 100.0)
    @hst_amount = @subtotal * (hst_rate / 100.0)
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

    gst = subtotal * (province&.gst.to_f / 100.0)
    pst = subtotal * (province&.pst.to_f / 100.0)
    hst = subtotal * (province&.hst.to_f / 100.0)
    total = subtotal + gst + pst + hst

    order = current_user.orders.create!(
      status: "pending",
      total: total,
      gst: gst,
      pst: pst,
      hst: hst,
      address: current_user.address
    )

    products.each do |product|
      quantity = cart[product.id.to_s].to_i

      order.order_items.create!(
        product: product,
        quantity: quantity,
        price: product.price
      )
    end

    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      line_items: [{
        price_data: {
          currency: "cad",
          product_data: {
            name: "Order #{order.id}"
          },
          unit_amount: (total * 100).to_i
        },
        quantity: 1
      }],
      mode: "payment",
      success_url: "#{request.base_url}/checkout/success?order_id=#{order.id}&session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{request.base_url}/cart"
    )

    order.update!(stripe_payment_id: stripe_session.id)

    redirect_to stripe_session.url, allow_other_host: true
  end
end