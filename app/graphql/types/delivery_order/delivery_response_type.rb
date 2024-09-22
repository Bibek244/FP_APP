module Types
 module  DeliveryOrder
  class DeliveryResponseType < Types::BaseObject
    field :delivery_order, [ Types::DeliveryOrder::DeliveryOrderType ], null: true
    field :errors, [ String ], null: false
    field :message, String, null: true
  end
 end
end
