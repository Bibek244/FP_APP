module OrderGroupServices
  class CreateOrderGroup
    attr_accessor :success, :errors
    attr_reader :order_group

    def initialize(create_order, current_user)
      @create_order = create_order
      @current_user = current_user
      @success = false
      @errors = []
    end

    def success?
      @success
    end

    def errors
      @errors.join(", ")
    end

    def execute
      call
      self
    end

    private

    def call
      ActiveRecord::Base.transaction do
        ActsAsTenant.current_tenant = @current_user.group
        customer_branch = find_customer_branch(@create_order[:customer_branch_id])
        customer = customer_branch.customer_id
        unless customer
          @errors << "Customer was not found"
          raise ActiveRecord::Rollback
        end

        @order_group = create_order_group(customer, customer_branch)
        delivery_order = create_delivery_order(@order_group, customer, customer_branch)
        create_line_items(delivery_order)

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

    def create_order_group(customer, customer_branch)
      OrderGroup.create!(
        group_id: @current_user.group_id,
        planned_at: @create_order[:planned_at],
        customer_id: customer,
        customer_branch_id: customer_branch.id,
        recurring: @create_order[:recurring],
        recurrence_frequency: @create_order[:recurrence_frequency],
        next_due_date: @create_order[:next_due_date],
        recurrence_end_date: @create_order[:recurrence_end_date]
      )
    end

    def create_delivery_order(order_group, customer, customer_branch)
      order_attributes = @create_order[:delivery_order_attributes]

      order_group.create_delivery_order!(
        group_id: @current_user.group_id,
        customer_id: customer,
        customer_branch_id: customer_branch.id,
        driver_id: order_attributes[:driver_id],
        vehicle_id: order_attributes[:vehicle_id],
        status: order_attributes[:status],
        dispatched_date: order_attributes[:dispatched_date],
        delivery_date: order_attributes[:delivery_date]
      )
    end

    def create_line_items(delivery_order)
      delivery_order_attributes = @create_order[:delivery_order_attributes]
      line_items_attributes = delivery_order_attributes[:lined_items_attributes]
      line_items_attributes.each do |item_attributes|
        delivery_order.line_items.create!(
          goods_id: item_attributes[:goods_id],
          quantity: item_attributes[:quantity],
          unit: item_attributes[:unit]
        )
      end
    end

    def handle_error(err)
      @success = false
      @errors << err.message
    end
  end
end
