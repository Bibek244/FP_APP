
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

        customer_branch = CustomerBranch.find_by(id: @create_order[:customer_branch_id])
        unless customer_branch
          @errors << "CustomerBranch was not found"
          raise ActiveRecord::Rollback
        end

        customer = customer_branch.customer_id
        unless customer
          @errors << "Customer was not found"
          raise ActiveRecord::Rollback
        end

        @order_group = OrderGroup.create!(
          group_id: @current_user.group_id,
          planned_at: @create_order[:planned_at],
          customer_id: customer,
          customer_branch_id: customer_branch.id,
          recurring: @create_order[:recurring],
          recurrence_frequency: @create_order[:recurrence_frequency],
          next_due_date: @create_order[:next_due_date],
          recurrence_end_date: @create_order[:recurrence_end_date]

        )
        @create_order[:lined_items_attributes].each do |item_attributes|
          line_item = @order_group.line_items.find_by(id: item_attributes[:id])

          if line_item
            line_item.update!(
              goods_id: item_attributes[:goods_id],
              quantity: item_attributes[:quantity]
            )
          else
            @order_group.line_items.create!(
              goods_id: item_attributes[:goods_id],
              quantity: item_attributes[:quantity]
            )
          end
          @success = true
          @errors = []
        end
      end
    rescue ActiveRecord::RecordInvalid => err
      @success = false
      @errors << err.message
    rescue => err
      @success = false
      @errors << err.message
    end
  end
end
