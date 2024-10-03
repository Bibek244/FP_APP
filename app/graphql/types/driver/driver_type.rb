# frozen_string_literal: true

module Types
 module Driver
  class DriverType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :email, String
    field :phone_no, String
    field :address, String
    field :status, Types::Driver::StatusEnum, null: false
    field :group_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
  end
 end
end
