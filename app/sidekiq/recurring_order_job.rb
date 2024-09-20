class RecurringOrderJob
  include Sidekiq::Job

  def perform
    DeliveryOrder.joins(:order_group).where(order_groups: { recurring: true }).each do |delivery_order|
      order_group = delivery_order.order_group
      if order_group.active_recurring?
        if Time.current > order_group.next_due_date
          update_delivery_order(delivery_order, order_group.next_due_date)
          next_due_date = calculate_next_due_date(order_group)
          order_group.update!(next_due_date: next_due_date)
        end
      end
    end
  end

  private

  def  update_delivery_order(delivery_order, next_due_date)
    delivery_order.update!(delivery_date: next_due_date)
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
