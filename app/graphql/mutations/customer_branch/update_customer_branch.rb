class ::Mutations::CustomerBranch::UpdateCustomerBranch < Mutations::BaseMutation
  argument :customerbranch_input, Types::CustomerBranch::CustomerBranchInputType, required: true
  argument :customerbranch_id, ID, required: true

  type Types::CustomerBranch::CustomerBranchResponseType, null: true

  def resolve(customerbranch_input:, customerbranch_id:)
    authorize
    current_user = context[:current_user]
    service = ::CustomerBranchServices::UpdateCustomerBranchService.new(customerbranch_id, customerbranch_input.to_h, current_user).execute

    if service.success?
      {
        customer_branch: service.customerbranch,
        message: "Successfully updated Customer Branch .",
        success: true,
        errors: []
        }
    else
        {
          customer_branch: nil,
          message: nil,
          success: false,
          errors: [ service.errors ]
        }
    end
  end
end
