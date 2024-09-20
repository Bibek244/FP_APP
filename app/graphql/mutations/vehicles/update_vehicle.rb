class ::Mutations::Vehicles::UpdateVehicle < Mutations::BaseMutation
  argument :vehicle_id, ID, required: true
  argument :vehicle_input, Types::Vehicles::VehiclesInputType, required: true

  type Types::Vehicles::VehiclesResultType, null: false

  def resolve(vehicle_id:, vehicle_input:)
    authorize
    current_user = context[:current_user]
    service = ::VehiclesServices::UpdateVehiclesServices.new(vehicle_id, vehicle_input.to_h, current_user).execute

    if service.success?
      { vehicle: [ service.vehicle ], message: "successfully created a vehicle", errors: [] }
    else
      { vehicle: nil, message: nil, errors: service.errors }
    end
  end
end
