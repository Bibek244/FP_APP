class Goods < ApplicationRecord
  include Availability

  validates :name, :category, :sold_as, :unit, presence: true
end
