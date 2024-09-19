class ::Resolvers::Driver::AllDrivers < Resolvers::BaseResolver
  type [ Types::Driver::DriverType ], null: false

  argument :group_id, ID, required: true
  def resolve(group_id:)
    Driver.where(group_id: group_id)
  end
end
