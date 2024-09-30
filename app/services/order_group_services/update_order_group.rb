module OrderGroupServices
  class UpdateOrderGroup
    attr_accessor :success, :errors
    attr_reader :order_group

    def initialize(order_group_id, update_order, current_user)
      @order_group_id = order_group_id
      @update_order = update_order
      @current_user = current_user
      @success = false
      @errors = []
    end

    def success?
      @success
    end

    def errors
      @errors
    end

    def execute
      call
      self
    end



    def call
      ActiveRecord::Base.transaction do
        ActsAsTenant.current_tenant = @current_user.group

        customer_branch = find_customer_branch(@update_order[:customer_branch_id])
        customer = customer_branch.customer_id

        if @update_order[:recurring]
          validate_recurrence_dates
        end

        @order_group = OrderGroup.find_by(id: @order_group_id)
        unless @order_group
          @errors << "Order group was not found."
          raise ActiveRecord::Rollback
        end
        update_order_group(@order_group, customer, customer_branch)

        if @order_group.parent_order_group.nil?
          update_child_order_groups(@order_group)
        end

        @success = true
      end
    rescue ActiveRecord::RecordInvalid => err
      handle_error(err)
    rescue => err
      handle_error(err)
    end

    def find_customer_branch(branch_id)
      customer_branch = CustomerBranch.find_by(id: branch_id)
      unless customer_branch
        @errors << "CustomerBranch was not found"
        raise ActiveRecord::Rollback
      end
      customer_branch
    end

    def validate_recurrence_dates
      recurrence_frequency = @update_order[:recurrence_frequency]
      recurrence_end_date = @update_order[:recurrence_end_date]
      planned_at = @update_order[:planned_at]

      case recurrence_frequency
      when "daily"
        if recurrence_end_date < planned_at + 1.day
          @errors << "For daily recurrence, recurrence_end_date must be at least a day from the planned_at date"
          raise ActiveRecord::Rollback
        end
      when "weekly"
        if recurrence_end_date < planned_at + 1.week
          @errors << "For weekly recurrence, recurrence_end_date must be at least a week from the planned_at date"
          raise ActiveRecord::Rollback
        end
      when "monthly"
        if recurrence_end_date < planned_at + 1.month
          @errors << "For monthly recurrence, recurrence_end_date must be at least a month from the planned_at date"
          raise ActiveRecord::Rollback
        end
      else
        @errors << "Invalid recurrence frequency"
        raise ActiveRecord::Rollback
      end
    end

    def update_order_group(order_group, customer, customer_branch)
      if @update_order[:planned_at] < Time.current
        @errors << "planned_at date cannot be in past "
        raise ActiveRecord::Rollback
      end
      recurrence_before_update = order_group.recurring?
      update_attributes = {
        group_id: @current_user.group_id,
        planned_at: @update_order[:planned_at],
        customer_id: customer,
        customer_branch_id: customer_branch.id,
        recurring: @update_order[:recurring],
        recurrence_frequency: @update_order[:recurrence_frequency],
        next_due_date: @update_order[:planned_at],
        recurrence_end_date: @update_order[:recurrence_end_date]
      }
      unless order_group.parent_order_group.nil?
        update_attributes =  update_attributes.merge(skip_update: true)
      end
      begin
        order_group.update!(update_attributes.except(:group_id))
        RecurringOrderJob.perform_async(order_group.id) if !recurrence_before_update
      rescue ActiveRecord::Rollback => err
        @errors << "Failed to update order_group #{err.record.errors.full_messages.join(', ')}"
      end
      update_delivery_order(order_group, customer, customer_branch)
      update_line_items(order_group.delivery_order)
    end

    def update_delivery_order(order_group, customer, customer_branch)
      delivery_order_attributes = @update_order[:delivery_order_attributes]
      status = delivery_order_attributes[:status]
      if status == "delivered" && order_group.delivery_order.dispatched_date.nil?
        @errors << "Cannot mark order as delivered without a dispatched date."
        raise ActiveRecord::Rollback
      end
      dispatched_date = case status
      when "on_the_way"
        order_group.delivery_order.dispatched_date || Time.current
      when "cancelled", "pending"
        nil
      else
        order_group.delivery_order.dispatched_date
      end

      delivery_date = case status
      when "delivered"
        Time.current
      when "cancelled", "pending", "on_the_way"
        nil
      else
        order_group.delivery_order.delivery_date
      end

      order_group.delivery_order.update!(
        group_id: @current_user.group_id,
        customer_id: customer,
        customer_branch_id: customer_branch.id,
        driver_id: delivery_order_attributes[:driver_id],
        vehicle_id: delivery_order_attributes[:vehicle_id],
        status: delivery_order_attributes[:status],
        dispatched_date: dispatched_date,
        delivery_date: delivery_date
      )
      case status
      when "on_the_way"
        DispatchOrderMailer.dispatch_delivery_mailer(customer, @order_group).deliver_now
      when "delivered"
        CompletedOrderMailer.completed_delivery_mailer(customer, @order_group).deliver_now
      when "cancelled"
        CancelOrderMailer.cancel_order_mailer(customer, @order_group).deliver_now
      end
    end

    def update_child_order_groups(parent_order_group)
      parent_order_group.child_order_groups.each do |child_order_group|
        next if child_order_group.skip_update

        update_attributes = {
          planned_at: @update_order[:planned_at],
          customer_id: parent_order_group.customer_id,
          customer_branch_id: parent_order_group.customer_branch_id
        }
      begin
        child_order_group.update!(update_attributes)
      rescue ActiveRecord::RecordInvalid => err
        @errors << "failed to update #{err.record.errors.full_messages.join(',')}"
      end
        # update_line_items(child_order_group.delivery_order)
        sync_line_items_from_parent_to_child(parent_order_group, child_order_group)
      end
    end

    def update_line_items(delivery_order)
      delivery_attributes = @update_order[:delivery_order_attributes]
      lined_items_attributes = delivery_attributes[:lined_items_attributes]
      lined_items_attributes.each do |item_attributes|
        if item_attributes[:id]
          line_item = delivery_order.line_items.find_by(id: item_attributes[:id])
          if line_item
            if item_attributes[:destroy] == true
              line_item.destroy!
            else
              begin
                validate_line_item_attributes!(item_attributes)
                line_item.update!(item_attributes.except(:id))
              rescue ActiveRecord::Rollback => err
                @errors << "Failed to update line_items: #{err.record.errors.full_messages.join(', ')}"
                raise ActiveRecord::Rollback
              end
            end
          else
            @errors << "LineItem with id #{item_attributes[:id]} not found"
            next
          end
        else
          begin
            delivery_order.line_items.create!(item_attributes.except(:destroy))
          rescue ActiveRecord::RecordInvalid => err
            @errors << "Failed to create line item: #{err.record.errors.full_messages.join(', ')}"
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    def sync_line_items_from_parent_to_child(parent_order_group, child_order_group)
      parent_line_items = parent_order_group.delivery_order.line_items

      child_order_group.delivery_order.line_items.destroy_all

      parent_line_items.each do |parent_item|
        child_order_group.delivery_order.line_items.create!(
          goods_id: parent_item.goods_id,
          quantity: parent_item.quantity,
          unit: parent_item.unit
        )
      end
    rescue ActiveRecord::RecordInvalid => err
      @errors << "Failed to copy line items to child order group: #{err.record.errors.full_messages.join(', ')}"
      raise ActiveRecord::Rollback
    end


    def validate_line_item_attributes!(item_attributes)
      if item_attributes[:goods_id].nil? || item_attributes[:quantity].nil?
        @errors << "Both goods_id and quantity must be provided."
        raise ActiveRecord::Rollback
      end
    end

    def handle_error(err)
      @success = false
      @errors << err.message
    end
  end
end
