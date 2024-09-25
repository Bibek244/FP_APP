module Types
  module OrderGroups
    class  OrderGroupResultType < Types::BaseObject
      field :order, Types::OrderGroups::OrderGroupType, null: true
      # field :customer, Types::Customer::CustomerType, null: true
      # field :customer_branch, Types::CustomerBranch::CustomerBranchType, null: true
      # field :child_order_groups, [ Types::OrderGroups::OrderGroupType ], null: true
      field :message, String, null: true
      field :errors, [ String ], null: false
    end
  end
end
