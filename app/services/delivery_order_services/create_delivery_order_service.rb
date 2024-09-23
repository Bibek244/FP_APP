module DeliveryOrderServices
  class CreateDeliveryOrderService
    attr_accessor :deliveryorder, :errors, :success, :message
    attr_reader :deliveryorder_input

    def initialize(deliveryorder_input = {})
      @deliveryorder = deliveryorder
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
          @deliveryorder = DeliveryOrder.create!(@deliveryorder_input.to_h.except(:status).merge(status: "pending"))
          @success = true
          @errors = []
          @message = ""
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
