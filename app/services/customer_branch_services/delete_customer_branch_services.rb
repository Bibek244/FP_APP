module CustomerBranchServices
  class DeleteCustomerBranchServices
    attr_accessor :errors, :success, :customerbranch, :message
    attr_reader :customerBranch_id

    def initialize(customerbranch_id)
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
      @errors
    end

    private
    def call
      begin
        ActiveRecord::Base.transaction do
          @customerbranch = CustomerBranch.find_by(id: @customerbranch_id)
          if @customerbranch.nil?
            raise ActiveRecord::RecordNotFound, "Customer with ID #{@customerbranch_id} not found"
          end
          @customerbranch.destroy
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
