class ::Mutations::CustomerBranch::AddCustomerBranch < Mutations::BaseMutation
  argument :branch_location, String, required: true
  argument :customer_id, ID, required: true

  field :customer_branch, Types::CustomerBranchType, null: true
  field :error, [ String ], null: true
  field :success, Boolean, null: true
  field :message, String, null: true

  def resolve(branch_location:, customer_id:)
    customer = Customer.find_by(id: customer_id)
    if customer.present?
      branch = CustomerBranch.new(branch_location: branch_location, customer_id: customer_id)
      if branch.save
        {
          customer_branch: branch,
          success: true,
          error: [],
          message: "New Branch location is added for #{customer.name}"
        }
      else
        {
          customer_branch: nil,
          success: false,
          error: branch.errors.full_messages,
          message: "New Branch location is not added for #{customer.name}"
        }
      end
    else
      {
        customer_branch: nil,
        success: true,
        error: [],
        message: "This Customer ID is not available"
      }
    end
  end
end
