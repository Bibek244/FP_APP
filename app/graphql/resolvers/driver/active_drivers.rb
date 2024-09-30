class ::Resolvers::Driver::ActiveDrivers < Resolvers::BaseResolver
  type [ Types::Driver::DriverType ], null: false

  def resolve
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    Driver.all.order(created_at: :desc)
  end
end
