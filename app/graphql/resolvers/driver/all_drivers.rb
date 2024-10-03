class ::Resolvers::Driver::AllDrivers < Resolvers::BaseResolver
  type [ Types::Driver::DriverType ], null: false

  # argument :group_id, ID, required: true
  def resolve
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    Driver.with_deleted.order(created_at: :desc)
  end
end
