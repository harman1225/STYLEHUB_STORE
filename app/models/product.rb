class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :stock, presence: true,
                  numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true

  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "price", "stock", "category_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
  ["category", "product_tags", "tags"]  end
end