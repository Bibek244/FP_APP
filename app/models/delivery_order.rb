class DeliveryOrder < ApplicationRecord
  acts_as_tenant(:group)
  belongs_to :customer_branch
  belongs_to :order_group
  belongs_to :vehicle
  belongs_to :driver
  belongs_to :customer

  has_many :line_items, dependent: :destroy
  enum status: { pending: "0", on_the_way: "1", delivered: "2", cancelled: "3" }
end
