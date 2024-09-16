module Types
  module CustomerBranch
    class CustomerBranchResponseType < Types::BaseObject
      field :customer_branch, Types::CustomerBranch::CustomerBranchType, null: true
      field :errors, [ String ], null: true
      field :success, Boolean, null: true
      field :message, String, null: true
    end
  end
end
