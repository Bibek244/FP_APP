module DeliveryOrderServices
  class CreateDeliveryOrderService
    attr_accessor :errors, :success
    attr_reader :delivery_order

    def initialize(delivery_order_input = {}, current_user)
      @delivery_order_input = delivery_order_input
      @current_user = current_user
      @success = false
      @errors = []
      @message = nil
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
      begin
        ActiveRecord::Base.transaction do
          @deliveryorder = DeliveryOrder.create!(@deliveryorder_input.to_h.except(:status).merge(status: "pending"))
          @success = true
          @errors = []
        end
      rescue ActiveRecord::RecordInvalid => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << err.message
      end
    end
  end
end
