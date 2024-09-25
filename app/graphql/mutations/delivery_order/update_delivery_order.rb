class ::Mutations::DeliveryOrder::UpdateDeliveryOrder < Mutations::BaseMutation
  argument :deliveryorder_input, Types::DeliveryOrder::DeliveryOrderInputType, required: true
  argument :deliveryorder_id, ID, required: true

  type Types::DeliveryOrder::DeliveryResponseType, null: true

  def resolve(deliveryorder_input:, deliveryorder_id:)
    authorize
    current_user = context[:current_user]
    service = ::DeliveryOrderServices::UpdateDeliveryOrderService.new(deliveryorder_id, deliveryorder_input.to_h, current_user).execute
    if service.success?
      {
        delivery_order: service.delivery_order,
        message: "Successfully updated Delivery Order.",
        errors: []
        }
    else
        {
          delivery_order: nil,
          message: nil,
          errors: [ service.errors ]
        }
    end
  end
end
