class Goods < ApplicationRecord
  acts_as_tenant(:group)
  include Availability

  belongs_to :category

  validates :name, :category, :sold_as, :unit, presence: true
  validates :name, length: { minimum: 3 }, uniqueness: { scope: :group_id }
  validates :sold_as, uniqueness: { scope: :group_id }
end
