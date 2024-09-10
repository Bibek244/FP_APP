class ::Resolvers::Driver::AllDrivers < Resolvers::BaseResolver
  type Types::DriverType, null: false

  def resolve
    drivers = Driver.all
    debugger
    Rails.logger.debug("Drivers: #{drivers.inspect}")
    drivers
  end
end
