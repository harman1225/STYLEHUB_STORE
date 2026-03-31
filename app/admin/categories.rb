ActiveAdmin.register Category do

  # ✅ FIX: allow name parameter
  permit_params :name

  # (optional but nice UI)
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

end