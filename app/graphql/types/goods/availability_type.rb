# app/graphql/types/availability_type.rb
module Types
 module Goods
  class AvailabilityType < Types::BaseEnum
    # Define the enum values and their descriptions
    value "in_stock", "The product is in stock"
    value "out_of_stock", "The product is out of stock"
    value "discontinued", "The product is discontinued"
  end
 end
end
