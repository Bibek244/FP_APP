module Types
  module DeliveryOrder
    class DeliveryStatus < Types::BaseEnum
      value "PENDING", "The order is pending and soon will be dispatched", value: "pending"
      value "ON_THE_WAY", "The order is dispatched and is on the way", value: "on_the_way"
      value "DELIVERED", "The order is successfully deliverd.", value: "deliverd"
      value "CANCELLED", " The order is cancelled.", value: "cancelled"
    end
  end
end