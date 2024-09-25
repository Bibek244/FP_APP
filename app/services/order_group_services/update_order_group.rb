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

    private

    def call
      ActiveRecord::Base.transaction do
        ActsAsTenant.current_tenant = @current_user.group

        customer_branch = find_customer_branch(@update_order[:customer_branch_id])
        customer = customer_branch.customer_id
        unless customer
          @errors << "Customer was not found"
          raise ActiveRecord::Rollback
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

    def update_order_group(order_group, customer, customer_branch)
      update_attributes = {
        group_id: @current_user.group_id,
        planned_at: @update_order[:planned_at],
        customer_id: customer,
        customer_branch_id: customer_branch.id
      }
      begin
        order_group.update!(update_attributes)
      rescue ActiveRecord::Rollback => err
        @errors << "Failed to update order_group #{err.record.errors.full_messages.join(', ')}"
      end
      update_delivery_order(order_group, customer, customer_branch)
      update_line_items(order_group.delivery_order)
    end

    def update_delivery_order(order_group, customer, customer_branch)
      delivery_order_attributes = @update_order[:delivery_order_attributes]

      order_group.delivery_order.update!(
        group_id: @current_user.group_id,
        customer_id: customer,
        customer_branch_id: customer_branch.id,
        driver_id: delivery_order_attributes[:driver_id],
        vehicle_id: delivery_order_attributes[:vehicle_id],
        status: delivery_order_attributes[:status],
        dispatched_date: delivery_order_attributes[:dispatched_date],
        delivery_date: delivery_order_attributes[:delivery_date]
      )
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
        update_line_items(child_order_group.delivery_order)
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
            raise ActiveRecord::Rollback
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
