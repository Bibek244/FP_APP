class ::Resolvers::Customer::AllCustomers < Resolvers::BaseResolver
  type [ Types::CustomerType ], null: true

  def resolve
    Customer.all
  end
end
