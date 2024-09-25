class Resolvers::OrderGroups::RecurrenceFrequenciesResolver < Resolvers::BaseResolver
  type [ String ], null: false
  def resolve
    Types::OrderGroups::RecurrenceFrequencyType.values.keys
  end
end
