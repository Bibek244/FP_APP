module CustomerBranchServices
  class CreateCustomerBranchService
    attr_accessor :errors, :success, :customerbranch
    attr_reader :customerbranch_input

    def initialize(customerbranch_input = {})
      @customerbranch_input = customerbranch_input
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
          @customerbranch = CustomerBranch.create!(@customerbranch_input.to_h)
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
