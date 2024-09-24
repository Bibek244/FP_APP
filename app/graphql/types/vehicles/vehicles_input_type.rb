module Types
  module Vehicles
    class VehiclesInputType < Types::BaseInputObject
      argument :license_plate, String, required: true
      argument :brand, String, required: true
      argument :vehicle_type, String, required: false
      argument :status, StatusType, required: true
      argument :capacity, Integer, required: true
      argument :image, [ String ], required: false
      # argument :group_id, ID, required: true
    end
  end
end
