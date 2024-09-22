class Resolvers::Goods::AllGoods < Resolvers::BaseResolver
  type Types::Goods::GoodsResultType, null: true

  def resolve
  authorize
  current_user = context[:current_user]
  ActsAsTenant.current_tenant = current_user.group

   goods =  Goods.all
   if goods.nil?
    raise GraphQL::ExecutionError, { goods: nil, message: nil, errors: [ "Could not featch goods." ] }
   else
    goods.to_a
    { goods: goods.order(created_at: :desc), message: "Successfully featched all the goods", errors: [] }
   end
  end
end
