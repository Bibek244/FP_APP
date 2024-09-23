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
          handle_status_update
        end
      rescue ActiveRecord::RecordInvalid => err
        @success = false
        @errors << err.message
      rescue => err
        @success = false
        @errors << err.message
      end
    end

    def handle_status_update
      @customer = @deliveryorder.customer.id
      new_status = @deliveryorder_input[:status]
      return unless new_status

      case new_status
      when  "delivered"
            perform_completed_actions

      when "on_the_way"
            perform_on_the_way_actions

      when "cancelled"
            perform_cancelled_actions
      end
    end

    #  when status is "completed"
    def perform_completed_actions
      CompletedOrderMailer.completed_delivery_mailer(@customer, @deliveryorder).deliver_now
    end

    # when status is "on_the_way"
    def perform_on_the_way_actions
      DispatchOrderMailer.dispatch_delivery_mailer(@customer, @deliveryorder).deliver_now
    end

    # when status is "cancelled"
    def perform_cancelled_actions
      CancelOrderMailer.cancel_order_mailer(@customer, @deliveryorder).deliver_now
    end
  end
end
