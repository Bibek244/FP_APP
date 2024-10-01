module CustomerBranchServices
  class ReactivateCustomerBranchServices
    attr_accessor :errors, :success, :customer_branch

    def initialize(customer_branch_id, current_user)
      @success = false
      @errors = []
      @customer_branch_id = customer_branch_id
      @current_user = current_user
    end

    def success?
      @success
    end

    def errors
      @errors
    end

    def execute
      call
      self
    end

    private

    def call
      ActsAsTenant.current_tenant = @current_user.group
      begin
        @customer_branch = CustomerBranch.with_deleted.find_by(id: @customer_branch_id)
        if @customer_branch.nil?
          @success = false
          @errors << "Customer branch not found"
        else
          if @customer_branch.recover
            @success = true
            @errors = []
          else
            @errors << @customer_branch.errors.full_messages
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
