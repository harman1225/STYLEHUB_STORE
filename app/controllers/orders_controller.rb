class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def success
    @order = current_user.orders.find(params[:id])
  end

  def ship
    @order = Order.find(params[:id])
    @order.update(status: "shipped")
    redirect_to orders_path, notice: "Order marked as shipped."
  end
end