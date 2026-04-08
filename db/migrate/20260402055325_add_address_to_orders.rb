class AddAddressToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :address, :string
  end
end
