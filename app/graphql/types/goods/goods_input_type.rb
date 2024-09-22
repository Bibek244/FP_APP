module Types
  module Goods
    class GoodsInputType < Types::BaseInputObject
      argument :name, String, required: true
      argument :sold_as, Types::Goods::SoldAsType, required: true
      argument :unit, String, required: true
      argument :category, Types::Goods::CategoryType, required: true
      argument :availability, Goods::AvailabilityType, required: true
    end
  end
end
