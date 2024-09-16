class Resolvers::OrderGroups::AllOrderGroup < Resolvers::BaseResolver
  type [ Types::OrderGroups::OrderGroupResultType ], null: false

  def resolve
    # Fetch all order groups with their associated line items
    order_groups = OrderGroup.includes(:line_items).all

    if order_groups.present?
      order_groups_result = order_groups.map do |order_group|
        {
          order: order_group,
          line_items: order_group.line_items,
          customer: order_group.customer,
          customer_branch: order_group.customer_branch,
          message: "Successfully fetched the order group.",
          errors: []
        }
      end
      order_groups_result
    else
      [ {
        order: nil,
        line_items: [],
        message: "No order groups found.",
        errors: [ "error: failed to fetch order groups" ]
      } ]
    end
  end
end
