class Resolvers::Category::AllCategory < Resolvers:: BaseResolver
  type Types::Category::CategoryResultType, null: true

  def resolve
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group
    categories = Category.order(desc: :create_at)

    if categories.empty?
      { category: nil, message: nil, errors: [ "No category found" ] }
    else
      { category: categories, message: "succesfully fetched category", errors: [] }
    end
  end
end
