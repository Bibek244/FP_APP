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
        if @create_order[:recurring]
          validate_recurrence_dates
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

    def validate_recurrence_dates
      recurrence_frequency = @create_order[:recurrence_frequency]
      recurrence_end_date = @create_order[:recurrence_end_date]
      planned_at = @create_order[:planned_at]

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

    def create_order_group(customer, customer_branch)
      if @create_order[:planned_at] < Time.current
        @errors << "planned_at date cannot be in past "
        raise ActiveRecord::Rollback
      end
      OrderGroup.create!(
        group_id: @current_user.group_id,
        planned_at: @create_order[:planned_at],
        customer_id: customer,
        customer_branch_id: customer_branch.id,
        recurring: @create_order[:recurring],
        recurrence_frequency: @create_order[:recurrence_frequency],
        next_due_date: @create_order[:planned_at],
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
        status: "pending",
        dispatched_date: nil,
        delivery_date: nil
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
