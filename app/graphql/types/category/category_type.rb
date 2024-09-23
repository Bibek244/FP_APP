# frozen_string_literal: true

module Types
  module Category
    class CategoryType < Types::BaseObject
      field :id, ID, null: false
      field :name, String
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :group_id, Integer, null: false
    end
  end
end
