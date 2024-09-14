class CustomerBranch < ApplicationRecord
  belongs_to :customer
  validates :branch_location, presence: true, uniqueness: { scope: :customer_id }
end
