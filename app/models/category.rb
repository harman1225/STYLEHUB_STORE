class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "created_at", "updated_at" ]
  end
end
