class Goods < ApplicationRecord
  acts_as_tenant(:group)
  include Availability

  validates :name, :category, :sold_as, :unit, presence: true
  # enum category: {AUTOMOBILE_FUEL: "0",AVIATION_FUEL: "1",GAS: "2", OTHERS: "3"}
  # enum sold_as: {PREMIUM: "0",MID_GRADE: "1", REGULAR_UNLEADED: "2", GAS:"3",OTHERS: "4"}
end
