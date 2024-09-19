class ::Mutations::CustomerBranch::AddCustomerBranch < Mutations::BaseMutation
  argument :customerbranch_input, Types::CustomerBranch::CustomerBranchInputType, required: true

  type Types::CustomerBranch::CustomerBranchResponseType, null: true

  def resolve(customerbranch_input:)
    authorize
    current_user = context[:current_user]
    service = CustomerBranchServices::CreateCustomerBranchService.new(customerbranch_input.to_h, current_user).execute
    
    if service.success?
      {
        customerbranch: service.customerbranch,
        message: "Successfully created new Customer Branch.",
        success: true,
        errors: []
      }
    else
      {
        customerbranch: nil,
        message: nil,
        success: false,
        errors: [service.errors]
      }
    end
  end
end
