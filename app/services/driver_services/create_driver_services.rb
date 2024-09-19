module DriverServices
  class CreateDriverServices
    attr_accessor :errors, :message, :driver, :success
    attr_reader :driver_input

    def initialize(driver_input = {}, current_user)
      @driver_input = driver_input
      @current_user = current_user
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
          ActsAsTenant.current_tenant = @current_user.group
          ActiveRecord::Base.transaction do
            @driver = Driver.create!(@driver_input.to_h.merge(group_id: @current_user.group_id))
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
