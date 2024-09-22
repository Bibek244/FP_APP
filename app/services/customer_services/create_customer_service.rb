
module CustomerServices
  class CreateCustomerService
    attr_accessor :errors, :success, :customer
    attr_reader :customer_input

    def initialize(customer_input = {})
      @customer_input = customer_input
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
          @customer = Customer.create!(@customer_input.to_h)
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
