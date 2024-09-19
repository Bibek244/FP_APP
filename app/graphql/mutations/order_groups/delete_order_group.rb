class Mutations::OrderGroups::DeleteOrderGroup < Mutations::BaseMutation
  argument :order_id, ID, required: true

  type Types::OrderGroups::OrderGroupResultType, null: false

  def resolve(order_id:)
   service = ::OrderGroupServices::DeleteOrderGroup.new(order_id).execute

   if service.success
    { order: service.order_group, message: "Successfully deleted the order group.", errors: [] }
   else
    { order: nil, message: nil, errors: [ service.errors ] }
   end
  end
end
