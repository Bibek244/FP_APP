   # app/graphql/types/availability_type.rb

   class Types::Vehicles::StatusType < Types::BaseEnum
     value "AVAILABLE", "The product is in stock", value: "available"
     value "IN_USE", "The product is out of stock", value: "in_use"
     value "MAINTENANCE", "The product is discontinued", value: "maintenance"
   end
