class ::Mutations::CustomerBranch::UpdateCustomerBranch < Mutations::BaseMutation
  argument :branch_location, String, required: true
  argument :id, ID, required: true

  field :customer_branch, Types::CustomerBranchType, null: true
  field :error, [ String ], null: true
  field :success, Boolean, null: true
  field :message, String, null: true

  def resolve(branch_location:, id:)
    branch = CustomerBranch.find_by(id: id)
    if branch.present?
      branch.update(branch_location: branch_location)
      if branch.save
        {
          customer_branch: branch,
          success: true,
          error: [],
          message: "Branch location is successfully updated"
        }
      else
        {
          customer_branch: nil,
          success: false,
          error: branch.errors.full_messages,
          message: "branch location is not updated"
        }
      end
    else
      {
        customer_branch: nil,
        success: true,
        error: [],
        message: "This Branch ID is not available"
      }
    end
  end
end
