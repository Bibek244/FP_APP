class Vehicle < ApplicationRecord
  acts_as_tenant(:group)
  include Status

  validates :license_plate, presence: true, uniqueness: true
  validates :brand, :vehicle_type, :capacity, presence: true


  # belongs_to :group
  has_many:delivery_orders
end
