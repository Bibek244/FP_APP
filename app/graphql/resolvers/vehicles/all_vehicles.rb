class Resolvers::Vehicles::AllVehicles < Resolvers::BaseResolver
  type Types::Vehicles::VehiclesResultType, null: true

  def resolve
    authorize

   vehicles =  Vehicle.all
   if vehicles.nil?
     { vehicle: nil, message: "No vehicles found.", errors: [] }
   else
    vehicles.to_a
    { vehicle: vehicles, message: "Successfully featched all the vehicles", errors: [] }
   end
  rescue => err
     raise GraphQL::ExecutionError, "An error occurred while fetching vehicles: #{err.message}"
  end
end
