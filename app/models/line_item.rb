class LineItem < ApplicationRecord
  belongs_to :goods
  belongs_to :delivery_order

  enum unit: { liters: 0, gallons: 1 }

  validates :quantity, numericality: { greater_than: 0 }, presence: true
  validates :unit, :goods_id, presence: true
end
