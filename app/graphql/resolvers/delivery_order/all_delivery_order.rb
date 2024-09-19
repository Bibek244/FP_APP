class ::Resolvers::DeliveryOrder::AllDeliveryOrder < Resolvers::BaseResolver
  argument :group_id, ID, required: true

  type Types::DeliveryOrder::DeliveryOrderType, null: true

  def resolve(group_id:)
    DeliveryOrder.find_by(group_id: group_id)
  end
end