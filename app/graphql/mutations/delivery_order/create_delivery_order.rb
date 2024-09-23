class ::Mutations::DeliveryOrder::CreateDeliveryOrder < Mutations::BaseMutation
  argument :deliveryorder_input, Types::DeliveryOrder::DeliveryOrderInputType, required: true

  type Types::DeliveryOrder::DeliveryResponseType, null: true

  def resolve(delivery_order_input:)
    authorize
    current_user = context[:current_user]

    service = ::DeliveryOrderServices::CreateDeliveryOrderService.new(delivery_order_input.to_h, current_user).execute

    if service.success?
      {
        deliveryorder: service.delivery_order,
        message: "Successfully created new Delivery Order.",
        errors: []
      }
    else
      {
        deliveryorder: nil,
        message: nil,
        errors: [ service.errors ]
      }
    end
  end
end
