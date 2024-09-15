# frozen_string_literal: true

module Types
  module OrderGroups
    class OrderGroupType < Types::BaseObject
      field :id, ID, null: false
      field :group_id, Integer, null: false
      field :planned_at, GraphQL::Types::ISO8601Date, null: false
      field :customer, Types::CustomerType, null: false
      field :customer_branch, Types::CustomerBranchType, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
