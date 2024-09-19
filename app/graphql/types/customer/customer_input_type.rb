module Types
  module Customer
    class CustomerInputType < Types::BaseInputObject
      argument :name, String, required: true
      argument :address, String, required: true
      argument :phone, Integer, required: true
      argument :email, String, required: true
    end
  end
end
