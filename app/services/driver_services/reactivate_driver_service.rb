module DriverServices
  class ReactivateDriverService
    attr_reader :driver, :errors, :message

    def initialize(driver_id, current_user)
      @current_user = current_user
      @driver_id = driver_id
      @success = false
      @errors = []
      @driver = nil
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
        @driver = Driver.with_deleted.find_by(id: @driver_id)

        if @driver.nil?
          @success = false
          @errors << "Driver not found"
        end

        if @driver.recover
          @success = true
          @errors = []
        else
          @errors << @driver.errors.full_messages
        end
      rescue ActiveRecord::RecordInvalid => err
        @errors << "Record not found: #{err.message}"
      rescue => err
        @errors << "An error occured: #{err.message}"
      end
    end
  end
end
