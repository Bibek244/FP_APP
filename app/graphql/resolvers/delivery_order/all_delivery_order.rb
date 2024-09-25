class ::Resolvers::DeliveryOrder::AllDeliveryOrder < Resolvers::BaseResolver
  type Types::DeliveryOrder::DeliveryResponseType, null: true

  def resolve(group_id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group

    delivery_orders = DeliveryOrder.where(group_id: group_id)

    if delivery_orders.any?
      {
        delivery_order: delivery_orders,
        message: "Successfully fetched delivery orders.",
        errors: []
      }
    else
      {
        delivery_order: nil,
        message: "No delivery orders found for the specified group.",
        errors: [ "No delivery orders found." ]
      }
    end
  end
end
