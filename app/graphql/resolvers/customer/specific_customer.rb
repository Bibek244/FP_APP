class ::Resolvers::Customer::SpecificCustomer < Resolvers::BaseResolver
  type Types::Customer::CustomerType, null: true

  argument :customer_id, ID

  def resolve(customer_id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    ::Customer.find_by(id: customer_id)
  end
end
