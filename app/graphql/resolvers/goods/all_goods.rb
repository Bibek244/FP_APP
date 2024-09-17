class Resolvers::Goods::AllGoods < Resolvers::BaseResolver
  type Types::Goods::GoodsResultType, null: true

  def resolve
  authorize

   goods =  Goods.all
   if goods.nil?
    raise GraphQL::ExecutionError, { goods: nil, message: nil, errors: [ "Could not featch goods." ] }
   else
    goods.to_a
    { goods: goods, message: "Successfully featched all the goods", errors: [] }
   end
  end
end
