module Resolvers
  module OrderGroups
    class UnitResolver < Resolvers::BaseResolver
      type [ String ], null: false

      def resolve
        Types::OrderGroups::UnitEnum.values.keys
      end
    end
  end
end
