class Resolvers::Goods::SpecificGoods < Resolvers::BaseResolver
  argument :goods_id, ID, required: true

  type Types::Goods::GoodsResultType, null: false

  def resolve(goods_id:)
    authorize
    current_user = context[:current_user]
    ActsAsTenant.current_tenant = current_user.group

    goods = Goods.where(id: goods_id)
    if goods.present?
      { goods: goods, message: "Successfully fetched the goods", errors: [] }
    else
      raise GraphQL::ExecutionError, { goods: nil, message: nil, errors: [ "Failed to fetch the goods." ] }
    end
  end
end
