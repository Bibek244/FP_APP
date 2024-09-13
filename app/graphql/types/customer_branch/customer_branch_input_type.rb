module Types
  module CustomerBranch
    class CustomerBranchInputType < Types::BaseInputObject
      argument :branch_location, String, required: true
      argument :customer_id, ID, required: true
    end
  end
end
