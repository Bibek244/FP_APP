module Types
  module Goods
   class CategoryType < Types::BaseEnum
     # Define the enum values and their descriptions
     value "AUTOMOBILE_FUEL", "The product is for Automobiles industry."
     value "AVIATION_FUEL", "The product is for the Aviation industry."
     value "GAS", "The product is for Home/industrial use"
     value "OTHERS", "For other types for fuel"
   end
  end
 end