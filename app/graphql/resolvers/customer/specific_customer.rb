class ::Resolvers::Customer::SpecificCustomer < Resolvers::BaseResolver
  type Types::Customer::CustomerType, null: true

  argument :customer_id, ID

  def resolve(customer_id:)
    ::Customer.find_by(id: customer_id)
  end
end
