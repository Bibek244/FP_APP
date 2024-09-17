class ::Mutations::Goods::DeleteGoods < Mutations::BaseMutation
  argument :goods_id, ID, required: true

  type Types::Goods::GoodsResultType, null: false

  def resolve(goods_id)
    authorize
    service =  ::GoodsServices::DeleteGoodsServices.new(goods_id).execute

    if service.success?
      { goods: [ service.goods ], message: "successfully deleted the product.", errors: [] }
    else
      { goods: nil, message: nil, errors: service.errors }
    end
  end
end
