class Vehicle < ApplicationRecord
  enum status: { availability: 0, in_user: 1, maintainance: 2 }

  validates brand:, model:, vin:, year:, mileage:, capacity:, status:, group_id:, presence: true
  validates vin:, uniqueness: true, length: { is: 17 }
  has_one :group
end
