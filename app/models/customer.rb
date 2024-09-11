class Customer < ApplicationRecord
  belongs_to :group
  validates :email, presence: true, uniqueness: { scope: :group_id }
  validates :phone, presence: true, uniqueness: { scope: :group_id }
  has_many :customer_branches
end
