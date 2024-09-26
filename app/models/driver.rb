class Driver < ApplicationRecord
  # belongs_to :group
  acts_as_tenant(:group)

  has_many :delivery_orders, dependent: :destroy

  enum status: { AVAILABLE: 0, UNAVAILABLE: 1, DEPLOYED: 2 }

  validates :email, presence: true, uniqueness: { scope: :group_id }, format: { with: Devise.email_regexp }
  validates :phone_no, presence: true, numericality: true, length: { is: 10 }, uniqueness: { scope: :group_id }
  validates :name, presence: true, length: { minimum: 3 }
  validates :address, presence: true, length: { minimum: 5 }
end
