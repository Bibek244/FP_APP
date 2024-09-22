class ::Resolvers::DeliveryOrder::SpecificDeliveryOrder < Resolvers::BaseResolver
  argument :delivery_id, ID, required: true

  type Types::DeliveryOrder::DeliveryOrderType, null: true

  def resolve(delivery_id:)
    delivery = DeliveryOrder.find_by(id: delivery_id)
    if delivery.nil?
      raise GraphQL::ExecutionError, "DeliveryOrder with ID #{delivery_id} not found"
    else
      delivery
    end
  end
end