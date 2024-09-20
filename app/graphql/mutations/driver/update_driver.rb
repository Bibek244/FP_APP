class ::Mutations::Driver::UpdateDriver < Mutations::BaseMutation
  argument :driver_input, Types::Driver::DriverInputType, required: true
  argument :driver_id, ID, required: true

  type Types::Driver::DriverResultType, null: true

  def resolve(driver_id:, driver_input:)
    authorize
    service = DriverServices::UpdateDriverService.new(driver_id, driver_input.to_h).execute
    if service.success?
      {
        driver: service.driver,
        message: "Successfully updated the driver value.",
        success: true,
        errors: []
        }
    else
        {
          driver: nil,
          message: nil,
          success: false,
          errors: [ service.errors ]
        }
    end
  end
end
