class Resolvers::OrderGroups::SpecificOrderGroup < Resolvers::BaseResolver
  type Types::OrderGroups::OrderGroupResultType, null: false

  argument :id, ID, required: true

  def resolve(id:)
    order_group = OrderGroup.find_by(id: id)
    if order_group.present?
      { order: order_group, line_items: order_group.line_items, customer: order_group.customer, customer_branch: order_group.customer_branch, message: "Successfully fetched the group_group.", errors: [] }
    else
      { order: order_group, message: nil, errors: [ "error: failed to fetch group" ] }
    end
  end
end
