
  class Resolvers::Goods::AvailabilityResolver < Resolvers::BaseResolver
   type [ String ], null: true
    def resolve
       Types::Goods::AvailabilityType.values.keys
    end
  end
