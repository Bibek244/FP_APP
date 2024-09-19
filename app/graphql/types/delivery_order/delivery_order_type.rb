# frozen_string_literal: true

module Types
  module DeliveryOrder
    class DeliveryOrderType < Types::BaseObject
      field :id, ID, null: false
      field :group_id, Integer, null: false
      field :customer_id, Integer, null: false
      field :customer_branch_id, Integer, null: false
      field :driver_id, Integer, null: false
      field :vehicle_id, Integer, null: false
      field :order_group_id, Integer, null: false
      field :status, String, null: false
      field :dispatched_date, GraphQL::Types::ISO8601Date
      field :delivery_date, GraphQL::Types::ISO8601Date
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
