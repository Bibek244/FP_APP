module VehiclesServices
  class UpdateVehiclesServices
    attr_accessor :success, :errors, :vehicle
    attr_reader :vehicle_input

    def initialize(id, vehicle_input = {})
      @vehicle_id = id
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
      ActiveRecord::Base.transaction do
        @vehicle = Vehicle.find_by(id: @vehicle_id)
        @vehicle.update!(@vehicle_input)
        @success = true
        @error = []
      end
    rescue ActiveRecord::RecordInvalid => err
      @success = false
      @errors < err.message
    rescue => err
      @success = false
      @errors < err.message
    end
  end
end
