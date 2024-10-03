class Mutations::Driver::ReactivateDriver < Mutations::BaseMutation
  argument :driver_id, ID, required: true

  type Types::Driver::DriverResultType, null: true

  def resolve (driver_id:)
    authorize
    current_user = context[:current_user]
    service = DriverServices::ReactivateDriverService.new(driver_id, current_user).execute

    if service.success?
      { driver: service.driver, message: "Successfully reactiveted driver.", errors: [] }
    else
      { driver: nil, message: nil, errors: service.errors }
    end
  end
end
