class RecurringOrderJob
  include Sidekiq::Job

  def perform
    DeliveryOrder.joins(:order_group)
    .where(order_groups: { recurring: true  })
    .where(order_groups: { parent_order_group_id: nil })
    .each do |delivery_order|
      order_group = delivery_order.order_group
        if order_group.active_recurring? && Time.current >= order_group.next_due_date

          next_due_date = calculate_next_due_date(order_group)

          order_group.update!(next_due_date: next_due_date)

          begin
            child_order_group = create_child_order_group(order_group, next_due_date)
            create_delivery_order(child_order_group, next_due_date, delivery_order)
          rescue ActiveRecord::RecordInvalid => e
            logger.error "Failed to create child order group or delivery order: #{e.message}"
          end
        end
    end
  end

  private

    def create_child_order_group(parent_order_group, next_due_date)
      child_order_group = parent_order_group.child_order_groups.create!(
        planned_at: next_due_date,
        group_id: parent_order_group.group_id,
        customer_id: parent_order_group.customer_id,
        customer_branch_id: parent_order_group.customer_branch_id,
        recurring: parent_order_group.recurring,
        recurrence_frequency: parent_order_group.recurrence_frequency,
        next_due_date: next_due_date,
        recurrence_end_date: parent_order_group.recurrence_end_date
      )

      parent_order_group.line_items.each do |parent_line_item|
        child_order_group.line_items.create!(
          parent_line_item.attributes.except("id", "created_at", "updated_at", "order_group_id")
        )
      end

      child_order_group
    end

  def create_delivery_order(child_order_group, next_due_date, delivery_order)
    DeliveryOrder.create!(
      order_group_id: child_order_group.id,
      vehicle_id: delivery_order[:vehicle_id],
      group_id: delivery_order[:group_id],
      driver_id: delivery_order[:driver_id],
      status: "pending",
      customer_id: delivery_order[:customer_id],
      customer_branch_id: delivery_order[:customer_branch_id],
      delivery_date: next_due_date
    )
  end

  def calculate_next_due_date(order_group)
    case order_group.recurrence_frequency
    when "daily"
      order_group.next_due_date + 1.day
    when "weekly"
      order_group.next_due_date + 1.week
    when "monthly"
      order_group.next_due_date.next_month
    else
      order_group.next_due_date
    end
  end
end
