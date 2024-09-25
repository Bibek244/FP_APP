# frozen_string_literal: true

class Mutations::OrderGroups::UpdateOrderGroup < Mutations::BaseMutation
  argument :update_order, Types::OrderGroups::OrderGroupInputType, required: true
  argument :order_group_id, ID, required: true

  type Types::OrderGroups::OrderGroupResultType, null: false
    def resolve(order_group_id:, update_order:)
      authorize
      current_user = context[:current_user]
      service = ::OrderGroupServices::UpdateOrderGroup.new(order_group_id, update_order.to_h, current_user).execute

      if service.success?
        { order: service.order_group, message: "successfully updated a order.", errors: [] }
      else
        { order: nil, line_items: nil, message: "Failed to update order.", errors: service.errors }
      end
    end
end
