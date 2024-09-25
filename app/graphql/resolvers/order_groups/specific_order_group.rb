class Resolvers::OrderGroups::SpecificOrderGroup < Resolvers::BaseResolver
  type Types::OrderGroups::OrderGroupResultType, null: false

  argument :id, ID, required: true

  def resolve(id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group

    order_group = OrderGroup.find_by(id: id)
    if order_group.present?
      if order_group.parent_order_group_id.nil?
        child_order_groups = order_group.child_order_groups
      else
        child_order_groups = []
      end
      { order: order_group,
        line_items: order_group.line_items,
        customer: order_group.customer,
        customer_branch: order_group.customer_branch,
        child_order_groups: child_order_groups,
        message: "Successfully fetched the group_group.",
        errors: [] }
    else
      { order: nil, message: nil, errors: [ "error: failed to fetch group" ] }
    end
  end
end
