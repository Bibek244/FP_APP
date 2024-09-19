module Types
  module OrderGroups
    class  OrderGroupResultType < Types::BaseObject
      field :order, Types::OrderGroups::OrderGroupType, null: true
      field :customer, Types::Customer::CustomerType, null: true
      field :customer_branch,Types::CustomerBranch::CustomerBranchType, null: true
      field :line_items, [ Types::OrderGroups::LineItemType ], null: true, method: :line_items
      field :message, String, null: true
      field :errors, [ String ], null: false
    end
  end
end
