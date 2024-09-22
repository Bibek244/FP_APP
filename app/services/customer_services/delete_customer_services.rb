module CustomerServices
  class DeleteCustomerServices
    attr_accessor :errors, :success, :customer, :message
    attr_reader :customer_id

    def initialize(customer_id, current_user = {})
      @customer_id = customer_id
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
      @errors
    end

    private
    def call
      begin
        ActsAsTenant.current_tenant = @current_user.group
        ActiveRecord::Base.transaction do
          @customer = Customer.find_by(id: @customer_id)
          if @customer.nil?
            raise ActiveRecord::RecordNotFound, "Customer with ID #{@customer_id} not found"
          end
          @customer.destroy
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
