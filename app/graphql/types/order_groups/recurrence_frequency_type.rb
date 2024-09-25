module Types
 module OrderGroups
  class RecurrenceFrequencyType < Types::BaseEnum
    value "DAILY",  "The order re-occurs daily", value: "daily"
    value "WEEKLY",  "The order re-occurs weekly", value: "weekly"
    value "MONTHLY",  "The order re-occurs monthly", value: "monthly"
  end
 end
end
