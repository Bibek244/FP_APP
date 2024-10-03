# frozen_string_literal: true

module Types
  module OrderGroups
    class OrderGroupType < Types::BaseObject
      field :id, ID, null: false
      field :group_id, Integer, null: false
      field :planned_at, GraphQL::Types::ISO8601Date, null: false
      field :customer, Types::Customer::CustomerType, null: true
      field :customer_branch, Types::CustomerBranch::CustomerBranchType, null: true
      field :recurring, Boolean, null: false
      field :recurrence_frequency, String, null: true
      field :next_due_date, GraphQL::Types::ISO8601Date, null: true
      field :recurrence_end_date, GraphQL::Types::ISO8601Date, null: true
      field :parent_order_group_id, ID, null: true
      field :line_items, [ Types::LineItem::LineItemType ], null: true
      field :child_order_groups, [ Types::OrderGroups::OrderGroupType ], null: true
      field :delivery_order, Types::DeliveryOrder::DeliveryOrderType, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
