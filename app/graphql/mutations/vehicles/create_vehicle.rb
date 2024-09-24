class ::Mutations::Vehicles::CreateVehicle < ::Mutations::BaseMutation
  argument :vehicle_input, Types::Vehicles::VehiclesInputType, required: true

  type Types::Vehicles::VehiclesResultType, null: false

  def resolve(vehicle_input:)
    authorize
    current_user = context[:current_user]
    service = ::VehiclesServices::CreateVehiclesServices.new(vehicle_input.to_h, current_user).execute

    if service.success?
      { vehicle: [ service.vehicle ], message: "successfully Added a vehicle", errors: [] }
    else
      { vehicle: nil, message: nil, errors: service.errors }
    end
  end
end
