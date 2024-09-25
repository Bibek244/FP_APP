class Resolvers::Category::SpecificCategory < Resolvers::BaseResolver
  type Types::Category::CategoryResultType, null: true

  argument :id, ID, required: true

  def resolve(id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    category = Category.find_by(id: id)
    if category.nil?
      { category: nil, message: "failed to fetch category", errors: [ "Category with ID #{id} not found" ] }
    else
      { category: [ category ], message: "succesfully fetched category", errors: [] }
    end
  end
end
