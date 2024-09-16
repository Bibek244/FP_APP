# frozen_string_literal: true

module Types
  module Customer
    class CustomerType < Types::BaseObject
      field :id, ID, null: false
      field :name, String
      field :address, String
      field :phone, String
      field :email, String
      field :group_id, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
