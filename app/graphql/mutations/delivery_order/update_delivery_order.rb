class ::Mutations::DeliveryOrder::UpdateDeliveryOrder < Mutations::BaseMutation

  argument :deliveryorder_input, Types::DeliveryOrder::DeliveryOrderInputType, required: true
  argument :deliveryorder_id, ID, required: true

  type Types::DeliveryOrder::DeliveryResponseType, null: true

  def resolve(deliveryorder_input:, deliveryorder_id:)
    authorize

    service = ::DeliveryOrderServices::UpdateDeliveryOrderService.new(deliveryorder_id, deliveryorder_input.to_h).execute
    if service.success?
      {
        deliveryorder: service.deliveryorder,
        message: "Successfully updated Delivery Order.",
        success: true,
        errors: []
        }
    else
        {
          deliveryorder: nil,
          message: nil,
          success: false,
          errors: [ service.errors ]
        }
    end
  end
end