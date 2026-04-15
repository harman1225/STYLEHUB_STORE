ActiveAdmin.register Order do
  permit_params :status
  config.filters = false

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :gst
    column :pst
    column :hst
    column :total
    column :created_at
    actions defaults: true do |order|
      if order.status != "shipped"
        link_to "Mark Shipped", ship_order_path(order), method: :patch
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :gst
      row :pst
      row :hst
      row :total
      row :payment_id
      row :created_at
      row :updated_at
    end

    panel "Ordered Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
        column("Line Total") { |item| item.quantity * item.price }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: [ "new", "paid", "shipped" ]
    end
    f.actions
  end
end
