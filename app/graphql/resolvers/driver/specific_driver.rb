class ::Resolvers::Driver::SpecificDriver < Resolvers::BaseResolver
  argument :driver_id, ID, required: true

  # type Types::Driver::DriverType, null: true
  type Types::Driver::DriverType, null: true

  def resolve(driver_id:)
    driver = ::Driver.find_by(id: driver_id)
    if driver.nil?
      raise GraphQL::ExecutionError, "Driver with ID #{driver_id} not found"
    end
    driver
  end
end
