class ::Resolvers::Driver::DriverStatus < Resolvers::BaseResolver
  type [ String ], null: false
  # field :description, String, null: true

  def resolve
    Types::Driver::StatusEnum.values.keys
  end
end
