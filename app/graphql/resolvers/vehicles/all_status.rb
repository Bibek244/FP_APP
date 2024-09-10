class Resolvers::Vehicles::AllStatus < Resolvers::BaseResolver
  type [ String ], null: false

  def resolve
    Types::Vehicles::StatusType.values.keys
  end
end
