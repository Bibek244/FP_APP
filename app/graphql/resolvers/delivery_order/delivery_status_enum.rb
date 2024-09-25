class Resolvers::DeliveryOrder::DeliveryStatusEnum < Resolvers::BaseResolver
  type [ String ], null: false

  def resolve
     Types::DeliveryOrder::DeliveryStatus.values.keys
  end
end
