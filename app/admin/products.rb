ActiveAdmin.register Product do

  # (Fix ForbiddenAttributesError)
  permit_params :name, :description, :price, :stock, :category_id, :image

  #  Filters (FIX for your error)
  filter :name
  filter :price
  filter :stock
  filter :category

  #  Form (Add/Edit Product)
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock
      f.input :category
      f.input :image, as: :file
    end
    f.actions
  end

  #  Index page (table view)
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock
    column :category

    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), width: 50
      else
        "No Image"
      end
    end

    actions
  end

  #  Show page (optional but useful)
  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock
      row :category
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), width: 150
        end
      end
    end
  end

end