class Customer < ApplicationRecord
  belongs_to :group
  validates :email, presence: true, uniqueness: { scope: :group_id }
  validates :phone, presence: true, uniqueness: { scope: :group_id }
  validates :name, presence: true
  validates :address, presence: true
  has_many :customer_branches
end
