module Types
  module Driver
    class DriverInputType < Types::BaseInputObject
      argument :name, String, required: true
      argument :email, String, required: true
      argument :address, String, required: true
      argument :phone_no, Integer, required: true
      argument :status, Types::Driver::StatusEnum, required: true
      argument :group_id, ID, required: true
      argument :user_id, ID, required: true
    end
  end
end
