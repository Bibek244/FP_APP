class CustomerBranch < ApplicationRecord
  acts_as_tenant(:group)
  
  belongs_to :customer, dependent: :destroy
  validates :branch_location, presence: true, uniqueness: { scope: :customer_id }
end
