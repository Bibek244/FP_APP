class Resolvers::Customer::ActiveCustomers < Resolvers::BaseResolver
  type [ Types::Customer::CustomerType ], null: true

  def resolve
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    Customer.all.order(created_at: :desc)
  end
end
