class ProductsController < ApplicationController

  def index
    @products = Product.all

    # Search
    if params[:keyword].present?
      @products = @products.where(
        "name LIKE ? OR description LIKE ?",
        "%#{params[:keyword]}%",
        "%#{params[:keyword]}%"
      )
    end

    #  Category filter
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    #  New products
    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    end

    #  Recently updated
    if params[:filter] == "updated"
      @products = @products.where("updated_at >= ?", 3.days.ago)
    end

    # 🔥 On Sale
    if params[:filter] == "sale"
      @products = @products.where(on_sale: true)
    end

    #  Pagination
    @products = @products.page(params[:page]).per(8)

    #  Categories
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end

end