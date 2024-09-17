class ::Resolvers::CustomerBranch::SpecificBranch < Resolvers::BaseResolver
  type Types::CustomerBranch::CustomerBranchType, null: true

  argument :id, ID, required: true

  def resolve(id:)
    authorize

    CustomerBranch.find_by(id: id)
  end
end
