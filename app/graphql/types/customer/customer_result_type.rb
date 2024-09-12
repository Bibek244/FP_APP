module Types
  module Customer
    class CustomerResultType < Types::BaseObject
      field :customer, Types::Customer::CustomerType, null: true
      field :errors, [ String ], null: true
      field :success, Boolean, null: true
      field :message, String, null: true
    end
  end
end
