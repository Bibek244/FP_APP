class ::Mutations::Driver::CreateDriver < Mutations::BaseMutation
  argument :driver_input, Types::Driver::DriverInputType, required: true

  type Types::Driver::DriverResultType, null: true

  def resolve(driver_input:)
    authorize
    current_user = context[:current_user]
    service = ::DriverServices::CreateDriverServices.new(driver_input.to_h, current_user).execute

    if service.success?
      {
        driver: service.driver,
        message: "Successfully created new Driver.",
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
