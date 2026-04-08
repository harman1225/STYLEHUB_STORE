ActiveAdmin.register Product do

  # (Fix ForbiddenAttributesError)
  permit_params :name, :description, :price, :stock, :category_id, :image, tag_ids: []

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
      f.input :price, input_html: { min: 0 }
      f.input :stock, input_html: { min: 0 }
      f.input :category
      f.input :image, as: :file
      f.input :tags, as: :check_boxes
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
      row :tags do |product|
  product.tags.map(&:name).join(", ")
end
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), width: 150
        end
      end
    end
  end

end