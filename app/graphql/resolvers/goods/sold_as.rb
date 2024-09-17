class ::Resolvers::Goods::SoldAs < Resolvers::BaseResolver
  type [ String ], null: false

  def resolve
    authorize
    Types::Goods::SoldAsType.values.keys
  end
end