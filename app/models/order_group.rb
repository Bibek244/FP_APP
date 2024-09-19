class OrderGroup < ApplicationRecord
  belongs_to :group
  belongs_to :customer
  belongs_to :customer_branch
  has_many :line_items, dependent: :destroy

  validates :group, :customer, :customer_branch, presence: true
end
