class Resolvers::Goods::AllCategory < Resolvers::BaseResolver
  type [String], null: false

  def resolve
    authorize
   Types::Goods::CategoryType.values.keys
  end
end
