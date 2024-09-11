class ::Mutations::CustomerBranch::DeleteCustomerBranch < Mutations::BaseMutation
  argument :customerbranch_id, ID, required: true

  field  :customer_branch, Types::CustomerBranchType, null: true
  field  :error, [ String ], null: true
  field :success, Boolean, null: true
  field :message, String, null: true

  def resolve(customerbranch_id:)
    branch = CustomerBranch.find_by(id: customerbranch_id)
    if branch.present?
      CustomerBranch.destroy(branch.id)
      {
        customer_branch: nil,
        error: [],
        success: true,
        message: "Customer Branch is deleted successfully for location #{branch.branch_location}"
      }
    else
      {
        customer_branch: nil,
        error: [],
        success: false,
        message: "CustomerID is invalid"
      }
    end
  end
end
