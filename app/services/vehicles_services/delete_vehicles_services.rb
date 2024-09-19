module VehiclesServices
  class DeleteVehiclesServices
    attr_accessor :success, :errors, :vehicle
    attr_reader :vehicle_id

    def initialize(vehicle_id, current_user)
      @vehicle_id = vehicle_id
      @current_user =current_user
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
        ActsAsTenant.current_tenant = @current_user.group
        @vehicle = Vehicle.find_by(id: @vehicle_id)
        @vehicle.destroy
        @success = true
        @errors = []
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
