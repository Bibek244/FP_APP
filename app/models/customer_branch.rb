class CustomerBranch < ApplicationRecord
  acts_as_tenant(:group)

  belongs_to :customer

  has_many :order_groups, dependent: :destroy
  has_many :delivery_order, dependent: :destroy

  validates :branch_location, presence: true, uniqueness: { scope: :customer_id }
end
