
module CustomerServices
  class CreateCustomerService
    attr_accessor :errors, :success, :customer
    attr_reader :customer_input

    def initialize(customer_input = {}, current_user = {})
      @customer_input = customer_input
      @current_user = current_user
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
        ActsAsTenant.current_tenant = current_user.group 
        @customer = Customer.new(@customer_input.merge(user_id: current_user.id, group_id: current_user.group_id))
        if @customer.save!
          @success = true
          @errors = []
          @message = ""
        else
          @success = false
          @error = ["Cannot create new customer"]
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

    def current_user
      @current_user
    end
  end
end
