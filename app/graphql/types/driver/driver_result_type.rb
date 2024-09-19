module Types
  module Driver
    class DriverResultType < Types::BaseObject
      field :driver, Types::Driver::DriverType, null: true
      field :errors, [ String ], null: true
      field :message, String, null: true
      field :success, Boolean, null: true
    end
  end
end
