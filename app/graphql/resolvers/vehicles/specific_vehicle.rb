class Resolvers::Vehicles::SpecificVehicle < Resolvers::BaseResolver
  argument :vehicle_id, ID, required: true

  type Types::Vehicles::VehiclesResultType, null: true

  def resolve(vehicle_id:)
    authorize

    vehicle = Vehicle.where(id: vehicle_id)
    if vehicle.present?
      { vehicle: vehicle, message: "Successfully fetched the vehicle.", errors: [] }
    else
      { vehicle: nil, message: "No vehicle with id #{vehicle_id} was found.", errors: [] }
    end
  rescue => err
      raise GraphQL::ExecutionError, "An error occurred while fetching vehicle: #{err.message}"
  end
end
