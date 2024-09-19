# frozen_string_literal: true

module Types
  class LineItemType < Types::BaseObject
    field :id, ID, null: false
    field :goods_id, Integer, null: false
    field :quantity, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
