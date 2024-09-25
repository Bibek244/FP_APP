module Mutations
  module Category
    class DeleteCategory < Mutataions::BaseMutation
      argument :id, ID, required: true

      type Types::Category::CategoryResultType

      def resolve(id:)
        authorize
        current_user = context[:current_user]
        ActsAsTenant.current_tenant = current_user.group

        category = Category.find_by(id: id)

        if category.nil?
          return {
            category: nil,
            errors: [ "Category not found." ],
            message: "Failed to delete category."
          }
        end

        if category.destroy
          {
            category: nil,
            errors: [],
            message: "Category deleted successfully."
          }
        else
          {
            category: nil,
            errors: [ "Failed to delete category." ],
            message: "Error occurred while deleting category."
          }
        end
      end
    end
  end
end
