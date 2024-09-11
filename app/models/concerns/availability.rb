module Availability
  extend ActiveSupport::Concern
  included do
    enum availability: { in_stock: 0, out_of_stock: 1, discontinued: 2 }


    validates :availability, presence: true
  end
end
