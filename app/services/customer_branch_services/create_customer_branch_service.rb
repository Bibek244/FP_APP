module CustomerBranchServices
  class CreateCustomerBranchService
    attr_accessor :errors, :success, :customerbranch
    attr_reader :customerbranch_input

    def initialize(customerbranch_input = {}, current_user = {})
      @customerbranch_input = customerbranch_input
      @current_user = current_user
      @success = false
      @errors = []
      @message = ""
      @customerbranch = nil
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
        ActsAsTenant.current_tenant = @current_user.group
        ActiveRecord::Base.transaction do
          @customerbranch = CustomerBranch.create!(@customerbranch_input.to_h.merge(group_id: @current_user.group_id))
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
