module VehiclesServices
  class ReactivateVehiclesServices
    attr_accessor :success, :errors, :vehicle

    def initialize(id, current_user)
      @vehicle_id = id
      @current_user = current_user
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
        @vehicle = Vehicle.with_deleted.find_by(id: @vehicle_id)
        if @vehicle.nil?
          raise ActiveRecord::Rollback, @errors << "Vehicle with id: #{@vehicle_id} not found!"
        end
        @vehicle.recover
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
