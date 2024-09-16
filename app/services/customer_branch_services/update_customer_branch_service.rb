module CustomerBranchServices
  class UpdateCustomerBranchService
    attr_accessor :errors, :message, :success, :customerbranch
    attr_reader :customerbranch_input

    def initialize(customerbranch_id, customerbranch_input = {})
      @customerbranch_input = customerbranch_input
      @customerbranch_id = customerbranch_id
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
        ActiveRecord::Base.transaction do
          @customerbranch = CustomerBranch.find_by(id: @customerbranch_id)
          if @customerbranch.nil?
            raise ActiveRecord::RecordNotFound, "Customerbranch with ID #{@customerbranch_id} not found"
          end
          @customerbranch.update!(@customerbranch_input.to_h)
          @success = true
          @errors = []
          @message = "Customer branch is updated successfully"
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
