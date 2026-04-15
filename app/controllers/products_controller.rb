class ProductsController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.all
    @category = nil

    if params[:keyword].present?
      @products = @products.where(
        "name LIKE ? OR description LIKE ?",
        "%#{params[:keyword]}%",
        "%#{params[:keyword]}%"
      )
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @category = Category.find_by(id: params[:category_id])
    end

    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    end

    if params[:filter] == "updated"
      @products = @products.where("updated_at >= ?", 3.days.ago)
                           .where("created_at < ?", 3.days.ago)
    end

    if params[:filter] == "sale"
      @products = @products.where(on_sale: true)
    end

    @products = @products.page(params[:page]).per(8)
  end

  def show
    @product = Product.find(params[:id])
    @category = @product.category
  end
end
