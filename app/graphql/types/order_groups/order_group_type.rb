# frozen_string_literal: true

module Types
  module OrderGroups
    class OrderGroupType < Types::BaseObject
      field :id, ID, null: false
      field :group_id, Integer, null: false
      field :planned_at, GraphQL::Types::ISO8601Date, null: false
      field :customer, Types::Customer::CustomerType, null: false
      field :customer_branch, Types::CustomerBranch::CustomerBranchType, null: false
      field :recurring, Boolean, null: false
      field :recurrence_frequency, String, null: true
      field :next_due_date, GraphQL::Types::ISO8601Date, null: true
      field :recurrence_end_date, GraphQL::Types::ISO8601Date, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
