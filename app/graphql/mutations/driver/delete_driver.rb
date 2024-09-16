class ::Mutations::Driver::DeleteDriver < Mutations::BaseMutation
  argument :driver_id, ID, required: true

  type Types::Driver::DriverResultType, null: true

  def resolve(driver_id:)
    service = ::DriverServices::DeleteDriverServices.new(driver_id).execute

    if service.success?
      {
        driver: service.driver,
        message: "Sucessfully deleted the Driver",
        errors: nil,
        success: true
      }
    else
      {
        customer: nil,
        message: nil,
        errors: service.errors,
        success: false
      }
    end
  end
end
