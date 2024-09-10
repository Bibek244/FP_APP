class Vehicle < ApplicationRecord
  include Status

  validates :license_plate, presence: true, uniqueness: true
  validates :brand, :vehicle_type, :capacity, presence: true


  belongs_to :group
end
