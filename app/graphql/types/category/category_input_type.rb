module Types
  module Category
    class CategoryInputType < Types::BaseInputObject
      argument :name, String, required: true
    end
  end
end
