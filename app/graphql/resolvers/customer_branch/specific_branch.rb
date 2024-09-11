class ::Resolvers::CustomerBranch::SpecificBranch < Resolvers::BaseResolver
  type Types::CustomerBranchType, null: true

  argument :id, ID, required: true

  def resolve(id:)
    CustomerBranch.find_by(id: id)
  end
end
