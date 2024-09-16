module DriverServices
  class UpdateDriverService
    attr_accessor :email, :message, :errors, :driver
    attr_reader :driver_id, :driver_input

    def initialize(driver_id, driver_input = {})
      @driver_id = driver_id
      @driver_input = driver_input
      @success = false
      @errors = []
      @message = ""
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
      @errors.join(", ")
    end
  private
    def call
      begin
        ActiveRecord::Base.transaction do
          @driver = Driver.find_by(id: @driver_id)
          if @driver.nil?
            raise ActiveRecord::RecordNotFound, "Driver with #{@driver_id} not found"
          end
          @driver.update(@driver_input.to_h)
          @success = true
          @errors = []
          @message = "Driver is updated successfully"
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
