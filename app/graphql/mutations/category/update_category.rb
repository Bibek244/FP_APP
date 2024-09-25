module Mutations
  module Category
    class UpdateCategory < Mutations::BaseMutation
      argument :id, ID, required: true
      argument :category_input, Types::Category::CategoryInputType, required: true

      type Types::Category::CategoryResultType

      def resolve(id:, category_input:)
        authorize
        current_user = context[:current_user]
        ActsAsTenant.current_tenant = current_user.group

        category = ::Category.find_by(id: id)

        if category.nil?
          return {
            category: nil,
            errors: [ "Category not found." ],
            message: "Failed to update category."
          }
        end

        if category.update(name: category_input.name)
          {
            category: [ category ],
            errors: [],
            message: "Category updated successfully."
          }
        else
          {
            category: nil,
            errors: category.errors.full_messages,
            message: "Failed to update category."
          }
        end
      end
    end
  end
end
