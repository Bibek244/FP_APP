class Driver < ApplicationRecord
  # belongs_to :group
  acts_as_tenant(:group)
  acts_as_paranoid
  has_many :delivery_orders

  before_destroy :nullify_delivery_orders_driver_id

  enum status: { AVAILABLE: "AVAILABLE", UNAVAILABLE: "UNAVAILABLE", DEPLOYED: "DEPLOYED" }

  validates :email, presence: true, uniqueness: { scope: :group_id }, format: { with: Devise.email_regexp }
  validates :phone_no, presence: true, numericality: true, length: { is: 10 }, uniqueness: { scope: :group_id }
  validates :name, presence: true, length: { minimum: 3 }
  validates :address, presence: true, length: { minimum: 5 }


  private

  def nullify_delivery_orders_driver_id
    delivery_orders.where(status: "pending").update_all(driver_id: nil)
    update(status: "UNAVAILABLE") if status != "UNAVAILABLE"
  end

  scope :active, -> { where(deleted_at: nil) }
end
