# frozen_string_literal: true

class Mutations::OrderGroups::CreateOrderGroup < Mutations::BaseMutation
argument :create_order, Types::OrderGroups::OrderGroupInputType, required: true

type Types::OrderGroups::OrderGroupResultType, null: false
  def resolve(create_order:)
    authorize
    current_user = context[:current_user]
    service = ::OrderGroupServices::CreateOrderGroup.new(create_order.to_h, current_user).execute

    if service.success?
      { order: service.order_group, message: "successfully created a order.", errors: [] }
    else
      { order: nil, line_items: nil, message: "Failed to created a order.", errors: [ service.errors ] }
    end
  end
end
