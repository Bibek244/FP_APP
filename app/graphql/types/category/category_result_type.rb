module Types
  module Category
    class CategoryResultType < Types::BaseObject
      field :category, Types::Category::CategoryType, null: true
      field :errors, [ String ], null: true
      field :message, String, null: true
    end
  end
end
