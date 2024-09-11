module Types
  module Vehicles
    class VehiclesResultType < Types::BaseObject
      field :vehicle, [ Types::Vehicles::VehiclesType ], null: true
      field :message, String, null: true
      field :errors, [ String ], null: false
    end
  end
end
