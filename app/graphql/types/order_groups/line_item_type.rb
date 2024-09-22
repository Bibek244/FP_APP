# frozen_string_literal: true

module Types
  module OrderGroups
    class LineItemType < Types::BaseObject
      field :id, ID, null: false
      field :goods_id, ID, null: false
      field :quantity, Integer
      field :unit, Types::OrderGroups::UnitEnum, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
