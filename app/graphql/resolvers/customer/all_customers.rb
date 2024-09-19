class ::Resolvers::Customer::AllCustomers < Resolvers::BaseResolver
  type [ Types::Customer::CustomerType ], null: true

  def resolve
    Customer.all
  end
end
