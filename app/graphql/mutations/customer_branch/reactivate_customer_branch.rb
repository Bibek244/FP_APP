class Mutations::CustomerBranch::ReactivateCustomerBranch < Mutations::BaseMutation
  argument :customer_branch_id, ID, required: true

  type Types::CustomerBranch::CustomerBranchResponseType, null: true

  def resolve (customer_branch_id:)
    authorize
    current_user = context[:current_user]
    service = CustomerBranchServices::ReactivateCustomerBranchServices.new(customer_branch_id, current_user).execute
    
    if service.success?
      { customer_branch: service.customer_branch, message: "Successfully reactiveted driver.", errors: [] }
    else
      { customer_branch: nil, message: nil, errors: service.errors }
    end
  end
end
