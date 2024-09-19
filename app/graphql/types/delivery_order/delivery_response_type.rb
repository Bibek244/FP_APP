module Types
 module  DeliveryOrder
  class DeliveryResponseType < Types::BaseObject
    field :deliveryorder, Types::DeliveryOrder::DeliveryOrderType, null: true
    field :errors, [String], null: true
    field :success, String, null: true
    field :message, String, null: true
  end
 end
end