class ::Mutations::Driver::DeleteDriver < Mutations::BaseMutation
  argument :driver_id, ID, required: true

  type Types::Driver::DriverResultType, null: true

  def resolve(driver_id:)
    authorize
    current_user = context[:current_user]
    service = ::DriverServices::DeleteDriverServices.new(driver_id, current_user).execute

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
