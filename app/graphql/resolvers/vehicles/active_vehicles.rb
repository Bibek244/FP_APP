class Resolvers::Vehicles::ActiveVehicles < Resolvers::BaseResolver
  type Types::Vehicles::VehiclesResultType, null: true

  def resolve
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group

   vehicles =  Vehicle.active
   if vehicles.nil?
     { vehicle: nil, message: "No vehicles found.", errors: [] }
   else
    vehicles.to_a
    { vehicle: vehicles.order(created_at: :desc), message: "Successfully featched all the vehicles", errors: [] }
   end
  rescue => err
     raise GraphQL::ExecutionError, "An error occurred while fetching vehicles: #{err.message}"
  end
end
