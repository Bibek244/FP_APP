module VehiclesServices
  class CreateVehiclesServices
    attr_accessor :errors, :success, :vehicle
    attr_reader :vehicle_input

    def initialize(vehicle_input = {}, current_user)
      @vehicle_input = vehicle_input
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
        @vehicle = Vehicle.create!(@vehicle_input.merge(group_id: @current_user.group_id))
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
