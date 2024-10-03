class ::Resolvers::Customer::AllCustomers < Resolvers::BaseResolver
  type [ Types::Customer::CustomerType ], null: true

  def resolve
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    Customer.with_deleted.order(created_at: :desc)
  end
end
