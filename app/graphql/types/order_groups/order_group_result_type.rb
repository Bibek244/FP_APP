module Types
  module OrderGroups
    class  OrderGroupResultType < Types::BaseObject
      field :order, Types::OrderGroups::OrderGroupType, null: true
      field :message, String, null: true
      field :errors, [ String ], null: false
    end
  end
end
