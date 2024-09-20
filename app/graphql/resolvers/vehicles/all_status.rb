class Resolvers::Vehicles::AllStatus < Resolvers::BaseResolver
  type [ String ], null: false

  def resolve
    authorize

    Types::Vehicles::StatusType.values.keys
  end
end
