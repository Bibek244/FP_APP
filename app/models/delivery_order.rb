class DeliveryOrder < ApplicationRecord
  belongs_to :customer_branch
  belongs_to :group
  belongs_to :order_group
  belongs_to :vehicle
  belongs_to :driver
  belongs_to :customer

  enum status: { pending: "0", on_the_way: "1", delivered: "2", cancelled: "3" }
end
