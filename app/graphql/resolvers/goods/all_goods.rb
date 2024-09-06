class Resolvers::Goods::AllGoods < Resolvers::BaseResolver
  type [ Types::Goods::GoodsType ], null: true


  def resolve
   goods =  Goods.all
   if goods.nil?
    raise GraphQL::ExecutionError, { goods: nil, message: nil, error: [ "Could not featch goods." ] }
   else
    goods.to_a
   end
  end
end
