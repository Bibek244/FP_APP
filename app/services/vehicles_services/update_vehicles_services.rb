module VehiclesServices
  class UpdateVehiclesServices
    attr_accessor :success, :errors, :vehicle
    attr_reader :vehicle_input

    def initialize(id, vehicle_input = {}, current_user)
      @vehicle_id = id
      @current_user = current_user
      @vehicle_input = vehicle_input
      @success = false
      @errors = []
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
      ActiveRecord::Base.transaction do
        @vehicle = Vehicle.find_by(id: @vehicle_id)
        @vehicle.update!(@vehicle_input)
        @success = true
        @error = []
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
