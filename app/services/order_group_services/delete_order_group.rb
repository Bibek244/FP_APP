module OrderGroupServices
  class DeleteOrderGroup
    attr_accessor :success, :errors
    attr_reader :order_group

    def initialize(order_id, current_user)
      @delete_order = order_id
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

        @order_group = OrderGroup.find_by(id: @delete_order)
        unless @order_group
          @errors << "Order Group doesnot exist."
          raise ActiveRecord.Rollback
        else
          if @order_group.parent_order_group.nil?
            delete_child_order_group(@order_group)
          end
          deliver_order = @order_group.delivery_order
          deliver_order.line_items.destroy
          deliver_order.destroy!
          @order_group.destroy!
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

    def delete_child_order_group(order_group)
      order_group.child_order_groups.each do |child_order_group|
        delivery_order = child_order_group.delivery_order
        if delivery_order&.status == "pending"
          delivery_order.destroy
          child_order_group.destroy
        end
      end
    end
  end
end
