# frozen_string_literal: true

module Types
  class CustomerBranchType < Types::BaseObject
    field :id, ID, null: false
    field :branch_location, String
    field :customer_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
