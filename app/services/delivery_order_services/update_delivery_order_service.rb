module DeliveryOrderServices
  class UpdateDeliveryOrderService
    attr_accessor :deliveryorder, :errors, :success, :message
    attr_reader :deliveryorder_input, :deliveryorder_id

    def initialize(deliveryorder_id, deliveryorder_input = {})
      @deliveryorder = nil
      @deliveryorder_id = deliveryorder_id
      @deliveryorder_input = deliveryorder_input
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
    
    def errros
      @errros.join(", ")
    end

    private
    def call
      begin
        ActiveRecord::Base.transaction do
          @deliveryorder = DeliveryOrder.find_by(id: @deliveryorder_id)
          if @deliveryorder.nil?
            raise ActiveRecord::RecordNotFound, "Delivery order not found"
          end
          @deliveryorder.update!(@deliveryorder_input.to_h)
          @success = true
          @errors = []
          @message = "Delivery Order is updated successfully"
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
end