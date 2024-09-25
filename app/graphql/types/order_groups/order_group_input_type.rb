module Types
  module OrderGroups
    class OrderGroupInputType < Types::BaseInputObject
      argument :planned_at, GraphQL::Types::ISO8601Date, required: true
      argument :customer_branch_id, ID, required: true
      argument :recurring, Boolean, required: false
      argument :recurrence_frequency, Types::OrderGroups::RecurrenceFrequencyType, required: false
      argument :next_due_date, GraphQL::Types::ISO8601Date, required: false
      argument :recurrence_end_date, GraphQL::Types::ISO8601Date, required: false
      argument :delivery_order_attributes,  DeliveryOrder::DeliveryOrderInputType, required: true
    end
  end
end
