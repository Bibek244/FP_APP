class LineItem < ApplicationRecord
  belongs_to :goods
  belongs_to :order_group
end
