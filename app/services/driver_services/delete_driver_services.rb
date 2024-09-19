module DriverServices
  class DeleteDriverServices
    attr_accessor :errors, :success, :driver, :message
    attr_reader :driver_id

    def initialize(driver_id, current_user)
      @driver_id = driver_id
      @current_user = current_user
      @errors = []
      @success = false
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

    def error
      @errors.join(", ")
    end

  private
  def call
    begin
      ActsAsTenant.current_tenant = @current_user.group
      ActiveRecord::Base.transaction do
        @driver = Driver.find_by(id: @driver_id)
        if @driver.nil?
          raise ActiveRecord::RecordNotFound, "Driver not found"
        end
        @driver.destroy
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
