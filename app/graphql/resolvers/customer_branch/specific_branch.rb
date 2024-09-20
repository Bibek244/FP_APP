class ::Resolvers::CustomerBranch::SpecificBranch < Resolvers::BaseResolver
  type Types::CustomerBranch::CustomerBranchType, null: true

  argument :id, ID, required: true

  def resolve(id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    CustomerBranch.find_by(id: id)
  end
end
