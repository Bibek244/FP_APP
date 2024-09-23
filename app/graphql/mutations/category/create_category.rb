class Mutations::Category::CreateCategory < Mutations::BaseMutation
    argument :category_input, Types::Category::CategoryInputType, required: true

    type Types::Category::CategoryResultType

  def resolve(category_input:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    category = Category.new(name: category_input.name, group_id: current_user.group_id)
    if category.save
      {
        category: category,
        errors: [],
        message: "Category created successfully."
      }
    else
      {
        category: nil,
        errors: category.errors.full_messages,
        message: "Failed to create category."
      }
    end
  end
end
