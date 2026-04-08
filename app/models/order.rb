class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  validates :status, presence: true
  validates :total, presence: true, numericality: true

  def subtotal
    order_items.sum { |item| item.price.to_f * item.quantity.to_i }
  end

  def tax_amount
    return 0 unless user&.province

    province = user.province

    gst_amount = subtotal * (province.gst.to_f / 100.0)
    pst_amount = subtotal * (province.pst.to_f / 100.0)
    hst_amount = subtotal * (province.hst.to_f / 100.0)

    gst_amount + pst_amount + hst_amount
  end

  def calculated_total
    subtotal + tax_amount
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "user_id", "status", "gst", "pst", "hst", "total", "stripe_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "user"]
  end
end