module Types
  module Goods
    class GoodsType < Types::BaseObject
      field :id, ID, null: false
      field :name, String
      field :category, String
      field :sold_as, String
      field :unit, String
      field :availability, AvailabilityType
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
