class Driver < ApplicationRecord
  belongs_to :group

  enum status: { AVAILABLE: 0, UNAVAILABLE: 1, DEPLOYED: 2 }
  validates :email, presence: true, uniqueness: { scope: :group_id }
  validates :phone_no, presence: true, uniqueness: { scope: :group_id }
  validates :name, presence: true
  validates :address, presence: true
  has_many :delivery_orders
end
