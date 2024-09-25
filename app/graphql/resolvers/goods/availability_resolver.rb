
  class Resolvers::Goods::AvailabilityResolver < Resolvers::BaseResolver
   type [ Types::Goods::AvailabilityType ], null: true
    def resolve
       Types::Goods::AvailabilityType.values.keys
    end
  end
