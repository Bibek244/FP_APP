class Goods < ApplicationRecord
  acts_as_tenant(:group)
  include Availability

  validates :name, :category, :sold_as, :unit, presence: true

  belongs_to :category
end
