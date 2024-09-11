class ::Resolvers::CustomerBranch::AllBranches < Resolvers::BaseResolver
  type [ Types::CustomerBranchType ], null: true

  def resolve
    CustomerBranch.all
  end
end
