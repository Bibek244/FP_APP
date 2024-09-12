  module CustomerServices
    class UpdateCustomerServices
      attr_accessor :errors, :message, :success, :customer
      attr_reader :customer_input

      def initialize(customer_id, customer_input = {})
        @customer_input = customer_input
        @customer_id = customer_id
        @success = false
        @errors = []
        @message = ""
        @customer = nil
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
            @customer = Customer.find_by(id: @customer_id)
            if @customer.nil?
              raise ActiveRecord::RecordNotFound, "Customer with ID #{@customer_id} not found"
            end
            @customer.update!(@customer_input.to_h)
            @success = true
            @errors = []
            @message = "Customer is updated successfully"
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
