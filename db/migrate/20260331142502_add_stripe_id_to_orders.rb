class AddStripeIdToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :stripe_id, :string
  end
end
