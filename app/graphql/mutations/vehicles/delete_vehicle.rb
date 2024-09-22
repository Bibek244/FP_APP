class Mutations::Vehicles::DeleteVehicle < Mutations::BaseMutation
  argument :vehicle_id, ID, required: true

  type Types::Vehicles::VehiclesResultType, null: false

  def resolve(vehicle_id:)
    authorize
    current_user = context[:current_user]
    service = ::VehiclesServices::DeleteVehiclesServices.new(vehicle_id, current_user).execute

    if service.success?
      { vehicle: [ service.vehicle ], message: "Successfully deleted vehicle.", errors: [] }
    else
      { vehicle: nil, message: "Failed to delete vehicle", errors: service.errors }
    end
  end
end
