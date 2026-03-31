class ProductsController < ApplicationController

  def index
    @products = Product.all

    # 🔍 Search
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

    #  New products (last 3 days)
    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    end

    #  Recently updated (last 3 days but NOT new)
    if params[:filter] == "updated"
      @products = @products.where("updated_at >= ? AND created_at < ?", 3.days.ago, 3.days.ago)
    end

    #  Pagination
    @products = @products.page(params[:page]).per(8)

    #  Categories for dropdown
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end

end