class Category < ApplicationRecord
  acts_as_tenant(:group)

  has_many :goods, class_name: "Goods"

  validates :name, presence: true,  uniqueness: { scope: :group_id }
end
