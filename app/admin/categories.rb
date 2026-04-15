ActiveAdmin.register Category do
  permit_params :name

  controller do
    def index
      @categories = Category.order(id: :desc)

      html = +""
      html << "<html><head><title>Categories</title>"
      html << "<style>"

      #  SIMPLE CLEAN STYLE
      html << "body{font-family:Arial,sans-serif;background:#f8f9fa;padding:30px;}"
      html << "h1{margin-bottom:20px;}"

      html << ".top-links{margin-bottom:20px;}"
      html << ".btn{padding:8px 14px;background:#007bff;color:#fff;border-radius:5px;text-decoration:none;margin-right:10px;}"
      html << ".btn:hover{background:#0056b3;}"

      html << "table{width:100%;border-collapse:collapse;background:#fff;}"
      html << "th,td{padding:10px;border:1px solid #ddd;text-align:left;}"
      html << "th{background:#e9ecef;}"

      html << ".actions a{margin-right:10px;color:#007bff;}"
      html << ".actions a:hover{text-decoration:underline;}"

      html << ".delete-btn{background:#dc3545;color:white;border:none;padding:6px 10px;border-radius:4px;cursor:pointer;}"
      html << ".delete-btn:hover{background:#c82333;}"

      html << "</style></head><body>"

      html << "<h1>Categories</h1>"

      html << "<div class='top-links'>"
      html << "<a class='btn' href='/admin'>Admin Home</a>"
      html << "<a class='btn' href='/admin/categories/new'>New Category</a>"
      html << "</div>"

      html << "<table>"
      html << "<thead><tr>"
      html << "<th>ID</th>"
      html << "<th>Name</th>"
      html << "<th>Created At</th>"
      html << "<th>Updated At</th>"
      html << "<th>Actions</th>"
      html << "</tr></thead><tbody>"

      @categories.each do |category|
        html << "<tr>"
        html << "<td>#{category.id}</td>"
        html << "<td>#{ERB::Util.html_escape(category.name)}</td>"
        html << "<td>#{category.created_at.strftime('%Y-%m-%d')}</td>"
        html << "<td>#{category.updated_at.strftime('%Y-%m-%d')}</td>"

        html << "<td class='actions'>"

        #  VIEW
        html << "<a href='/admin/categories/#{category.id}'>View</a>"

        #  EDIT
        html << "<a href='/admin/categories/#{category.id}/edit'>Edit</a>"

        #  DELETE (WORKING PROPERLY)
        html << "<form action='/admin/categories/#{category.id}' method='post' style='display:inline;'>"
        html << "<input type='hidden' name='_method' value='delete'>"
        html << "<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'>"
        html << "<button type='submit' class='delete-btn' onclick=\"return confirm('Delete this category?')\">Delete</button>"
        html << "</form>"

        html << "</td>"
        html << "</tr>"
      end

      html << "</tbody></table>"
      html << "</body></html>"

      render html: html.html_safe
    end
  end

  #  SHOW PAGE (works)
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end

  # FORM (works)
  form do |f|
    f.inputs "Category Details" do
      f.input :name
    end
    f.actions
  end
end
