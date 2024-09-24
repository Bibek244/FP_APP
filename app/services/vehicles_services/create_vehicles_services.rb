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
        @vehicle = Vehicle.create!(@vehicle_input.except(:image).merge(group_id: @current_user.group_id))
        if @vehicle_input[:image].present?
          attach_image_to_vehicle(@vehicle, @vehicle_input[:image])
        end
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

    def attach_image_to_vehicle(vehicle, images)
      images.each_with_index do |base64_image, index|
        if base64_image.is_a?(String) && base64_image.include?(",")
          decoded_image = Base64.decode64(base64_image.split(",").last)
          io = StringIO.new(decoded_image)
          vehicle.images.attach(
            io: io,
            filename: "vehicle_#{vehicle.id}_#{index}.png",
            content_type: "image/png" # You can set dynamically based on input
          )
        end
      end
    end
  end
end
