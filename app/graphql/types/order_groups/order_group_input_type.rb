module Types
  module OrderGroups
    class OrderGroupInputType < Types::BaseInputObject
      argument :group_id, ID, required: true
      argument :planned_at, GraphQL::Types::ISO8601Date, required: true
      argument :customer_branch_id, ID, required: true
      argument :lined_items_attributes, [ Types::OrderGroups::LineItemInputType ], required: false
    end
  end
end
