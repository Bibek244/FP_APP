class Vehicle < ApplicationRecord
  acts_as_tenant(:group)
  acts_as_paranoid
  include Status

  validates :license_plate, presence: true, uniqueness: true
  validates :brand, :vehicle_type, :capacity, presence: true


  # belongs_to :group
  has_many :delivery_orders

  private

  def nullify_delivery_orders_vehicle_id
    delivery_orders.where(status: "pending").update_all(vehicle_id: nil)
  end

  scope :active, -> { where(deleted_at: nil) }
end
