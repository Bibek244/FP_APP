class ::Resolvers::Driver::SpecificDriver < Resolvers::BaseResolver
  argument :driver_id, ID, required: true

  # type Types::Driver::DriverType, null: true
  type Types::Driver::DriverType, null: true

  def resolve(driver_id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    driver = ::Driver.find_by(id: driver_id)
    if driver.nil?
      raise GraphQL::ExecutionError, "Driver with ID #{driver_id} not found"
    end
    driver
  end
end
