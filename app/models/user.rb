class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  def update_without_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "email",
      "address",
      "province_id",
      "created_at",
      "updated_at",
      "remember_created_at",
      "reset_password_sent_at",
      "reset_password_token"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders", "province"]
  end

  protected

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end