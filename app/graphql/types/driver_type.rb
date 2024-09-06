# frozen_string_literal: true

module Types
  class DriverType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :email, String
    field :phone_no, Integer
    field :address, String
    field :status, Integer, null: false
    field :group_id, Integer, null: false
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
