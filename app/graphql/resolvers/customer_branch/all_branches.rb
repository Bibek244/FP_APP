class ::Resolvers::CustomerBranch::AllBranches < Resolvers::BaseResolver
  type [ Types::CustomerBranch::CustomerBranchType ], null: true

  argument :customer_id, ID,  required: true

  def resolve(customer_id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    ::CustomerBranch.with_deleted.where(customer_id: customer_id).order(created_at: :desc)
  end
end
