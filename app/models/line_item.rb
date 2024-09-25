class LineItem < ApplicationRecord
  belongs_to :goods
  belongs_to :order_group

  enum unit: { liters: 0, gallons: 1 }
end
