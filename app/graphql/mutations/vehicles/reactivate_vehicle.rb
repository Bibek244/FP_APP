class ::Mutations::Vehicles::ReactivateVehicle < Mutations::BaseMutation
  argument :vehicle_id, ID, required: true

  type Types::Vehicles::VehiclesResultType, null: false

  def resolve(vehicle_id:)
    authorize
    current_user = context[:current_user]
    service = ::VehiclesServices::ReactivateVehiclesServices.new(vehicle_id, current_user).execute

    if service.success?
      { vehicle: [ service.vehicle ], message: "successfully created a vehicle", errors: [] }
    else
      { vehicle: nil, message: nil, errors: service.errors }
    end
  end
end
