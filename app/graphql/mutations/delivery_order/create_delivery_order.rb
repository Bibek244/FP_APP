class ::Mutations::DeliveryOrder::CreateDeliveryOrder < Mutations::BaseMutation
  argument :deliveryorder_input, Types::DeliveryOrder::DeliveryOrderInputType, required: true
  
  type Types::DeliveryOrder::DeliveryResponseType, null: true
  
  def resolve(deliveryorder_input:)
    authorize

    service = ::DeliveryOrderServices::CreateDeliveryOrderService.new(deliveryorder_input.to_h).execute
    
    if service.success?
      {
        deliveryorder: service.deliveryorder,
        message: "Successfully created new Delivery Order.",
        success: true,
        errors: []
      }
    else
      {
        deliveryorder: nil,
        message: nil,
        success: false,
        errors: [service.errors]
      }
    end
  end
end