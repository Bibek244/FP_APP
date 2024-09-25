# app/graphql/types/availability_type.rb
module Types
 module Goods
  class AvailabilityType < Types::BaseEnum
    # Define the enum values and their descriptions
    value  "IN_STOCK", "The product is in stock", value: "in_stock"
    value  "OUT_OF_STOCK", "The product is out of stock", value: "out_of_stock"
    value  "DISCOUNTINUED", "The product is discontinued", value: "discontinued"
  end
 end
end
