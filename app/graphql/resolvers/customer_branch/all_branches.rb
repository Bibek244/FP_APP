class ::Resolvers::CustomerBranch::AllBranches < Resolvers::BaseResolver
  type [ Types::CustomerBranchType ], null: true

  argument :customer_id, ID,  required: true

  def resolve(customer_id:)
    CustomerBranch.where(customer_id: customer_id)
  end
end
