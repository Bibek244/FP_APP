# frozen_string_literal: true

module Types
  module Vehicles
    class VehiclesType < Types::BaseObject
      field :id, ID, null: false
      field :license_plate, String, null: true
      field :brand, String, null: true
      field :vehicle_type, String, null: true
      field :status, ::Types::Vehicles::StatusType, null: false
      field :capacity, Integer, null: true
      field :group_id, ID, null: false
      field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
    end
  end
end
