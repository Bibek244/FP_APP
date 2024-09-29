module Availability
  extend ActiveSupport::Concern
  included do
    enum availability: { in_stock: "IN_STOCK", out_of_stock: "OUT_OF_STOCK", discontinued: "DISCONTINUED" }


    validates :availability, presence: true
  end
end
