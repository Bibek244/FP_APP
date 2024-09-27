class RecurringOrderJob
  include Sidekiq::Job

  def perform(order_group_id)
    order_group = OrderGroup.find_by(id: order_group_id)
    delivery_order = order_group.delivery_order
    next_due_date = calculate_next_due_date(order_group)
    while next_due_date < order_group.recurrence_end_date
      child_order_group = create_child_order_group(order_group, next_due_date)
      create_delivery_order(child_order_group, delivery_order)
      next_due_date = calculate_next_due_date(child_order_group)
    end
  end

  private

  def create_child_order_group(parent_order_group, next_due_date)
    child_order_group = parent_order_group.child_order_groups.create(
      planned_at: next_due_date,
      group_id: parent_order_group.group_id,
      customer_id: parent_order_group.customer_id,
      customer_branch_id: parent_order_group.customer_branch_id,
      recurring: false
    )
    child_order_group
  end

  def create_delivery_order(child_order_group, delivery_order)
    new_delivery_order = DeliveryOrder.create!(
      order_group_id: child_order_group.id,
      vehicle_id: delivery_order[:vehicle_id],
      group_id: delivery_order[:group_id],
      driver_id: delivery_order[:driver_id],
      status: "pending",
      customer_id: delivery_order[:customer_id],
      customer_branch_id: delivery_order[:customer_branch_id]
    )

    delivery_order.line_items.each do |parent_line_item|
    new_delivery_order.line_items.create!(
      parent_line_item.attributes.except("id", "create_at", "updated_at", "order_group_id")
    )
    end
  end

  def calculate_next_due_date(order_group)
    frequency = order_group.recurrence_frequency || order_group.parent_order_group.recurrence_frequency
    next_due_date = order_group.next_due_date || order_group.planned_at
    case frequency
    when "daily"
      next_due_date + 1.day
    when "weekly"
      next_due_date + 1.week
    when "monthly"
      next_due_date.next_month
    else
      raise "Unkown frequency"
    end
  end
end
