class ::Resolvers::Driver::DriverStatus < Resolvers::BaseResolver
  type [ String ], null: false
  def resolve
      Types::Driver::StatusEnum.values.keys
  end
end
