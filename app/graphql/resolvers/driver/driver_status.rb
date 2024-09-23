class ::Resolvers::Driver::DriverStatus < Resolvers::BaseResolver
  type [ Types::Driver::StatusEnum ], null: false
  def resolve
    Types::Driver::StatusEnum.values.keys
  end
end
