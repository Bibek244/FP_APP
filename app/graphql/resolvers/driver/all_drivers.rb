class ::Resolvers::Driver::AllDrivers < Resolvers::BaseResolver
  type [ Types::DriverType ], null: false

  def resolve
    Driver.all
  end
end
