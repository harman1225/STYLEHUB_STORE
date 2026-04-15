class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag

  def self.ransackable_attributes(auth_object = nil)
  [ "id", "product_id", "tag_id", "created_at", "updated_at" ]
end

def self.ransackable_associations(auth_object = nil)
  [ "product", "tag" ]
end
end
