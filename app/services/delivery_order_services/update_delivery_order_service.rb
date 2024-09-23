module DeliveryOrderServices
  class UpdateDeliveryOrderService
    attr_accessor :errors, :success
    attr_reader :delivery_order

    def initialize(delivery_order_id, deliveryorder_input = {}, current_user)
      @delivery_order_id = delivery_order_id
      @delivery_order_input = delivery_order_input
      @current_user = current_user
      @success = false
      @errors = []
    end

    def execute
      call
      self
    end

    def success?
      @success
    end

    def errors
      @errors.join(", ")
    end

    private
    def call
      ActiveRecord::Base.transaction do
        ActsAsTenant.current_tenant = @current_user.group
        @delivery_order = DeliveryOrder.find_by(id: @delivery_order_id)
        if @delivery_order.nil?
          raise ActiveRecord::RecordNotFound, "Delivery order not found"
        end
        @delivery_order.update!(@deliveryorder_input.to_h.merge(group_id: @current_user.group))
        @success = true
        @errors = []
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
