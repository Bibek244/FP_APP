class Resolvers::DeliveryOrder::SpecificDeliveryOrder < Resolvers::BaseResolver
  argument :delivery_id, ID, required: true

  type Types::DeliveryOrder::DeliveryResponseType, null: true

  def resolve(delivery_id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group

    delivery = DeliveryOrder.find_by(id: delivery_id)

    if delivery
      {
        delivery_order: [ delivery ],
        message: "Successfully fetched the delivery order.",
        errors: []
      }
    else
      {
        delivery_order: nil,
        message: nil,
        errors: [ "DeliveryOrder with ID #{delivery_id} not found" ]
      }
    end
  end
end
