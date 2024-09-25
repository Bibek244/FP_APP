class LineItem < ApplicationRecord
  belongs_to :goods
  belongs_to :delivery_order
  enum unit: { liters: 0, gallons: 1 }
end
