class Resolvers::Goods::SpecificGoods < Resolvers::BaseResolver
  argument :goods_id, ID, required: true

  type Types::Goods::GoodsResultType, null: false

  def resolve(goods_id:)
    debugger
    goods = Goods.find_by(id: goods_id)
    if goods.present?
      { goods: goods, message: "Successfully fetched the goods", errors: [] }
    else
      raise GraphQL::ExecutionError, { goods: nil, message: nil, errors: [ "Failed to fetch the goods." ] }
    end
  end
end
