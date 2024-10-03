module CustomerServices
  class ReactivateCustomerServices
    attr_accessor :errors, :success, :customer

    def initialize(customer_id, current_user)
      @success = false
      @errors = []
      @customer_id = customer_id
      @current_user = current_user
    end

    def execute
      call
      self
    end

    def success?
      @success
    end

    def errors
      @errors
    end

    private

    def call
      ActsAsTenant.current_tenant = @current_user.group
      begin
        @customer = Customer.with_deleted.find_by(id: @customer_id)

        if @customer.nil?
          @success = false
          @errors << "Customer not found"
        else
          if @customer.recover
            @success = true
            @errors = []
          else
            @errors << @customer.errors.full_messages
          end
        end
      rescue ActiveRecord::RecordInvalid => err
        @errors << "Record Invalid: #{err.message}"
      rescue => err
        @errors << "An error occured: #{err.message}"
      end
    end
  end
end
