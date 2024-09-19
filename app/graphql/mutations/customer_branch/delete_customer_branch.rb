class ::Mutations::CustomerBranch::DeleteCustomerBranch < Mutations::BaseMutation
  argument :customerbranch_id, ID, required: true

  type Types::CustomerBranch::CustomerBranchResponseType, null: false

  def resolve(customerbranch_id:)
    service = ::CustomerBranchServices::DeleteCustomerBranchServices.new(customerbranch_id).execute

    if service.success?
      {
        customerbranch: service.customerbranch,
        message: "Customer branch deleted Successfully",
        errors: nil,
        success: true
      }
    else
      {
        customerbranch: nil,
        message: nil,
        errors: service.errors,
        success: false
      }
    end
  end
end
