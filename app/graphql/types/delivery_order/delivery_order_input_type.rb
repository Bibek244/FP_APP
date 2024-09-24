module Types
  module DeliveryOrder
    class DeliveryOrderInputType < Types::BaseInputObject
      argument :customer_id, ID, required: false
      argument :customer_branch_id, ID, required: false
      argument :driver_id, ID, required: true
      argument :vehicle_id, ID, required: true
      argument :order_group_id, ID, required: false
      argument :lined_items_attributes, [ Types::LineItem::LineItemInputType ], required: true
      argument :status, Types::DeliveryOrder::DeliveryStatus, required: true
      argument :dispatched_date, GraphQL::Types::ISO8601Date
      argument :delivery_date, GraphQL::Types::ISO8601Date
    end
  end
end
