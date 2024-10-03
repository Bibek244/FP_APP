class ::Mutations::CustomerBranch::DeleteCustomerBranch < Mutations::BaseMutation
  argument :customerbranch_id, ID, required: true

  type Types::CustomerBranch::CustomerBranchResponseType, null: false

  def resolve(customerbranch_id:)
    authorize
    current_user = context[:current_user]
    service = ::CustomerBranchServices::DeleteCustomerBranchServices.new(customerbranch_id, current_user).execute

    if service.success?
      {
        customer_branch: service.customerbranch,
        message: "Customer branch deleted Successfully",
        errors: nil,
        success: true
      }
    else
      {
        customer_branch: nil,
        message: nil,
        errors: service.errors,
        success: false
      }
    end
  end
end
