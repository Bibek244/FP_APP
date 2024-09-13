module DriverServices
  class CreateDriverServices
    attr_accessor :errors, :message, :driver, :success
    attr_reader :driver_input

    def initialize(driver_input = {})
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
            @driver = Driver.create!(@driver_input.to_h)
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
