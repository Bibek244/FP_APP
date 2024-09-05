class ::Mutations::Goods::UpdateGoods < Mutations::BaseMutation
  argument :goods_input, Types::InputObject::GoodsInputType, required: true
  argument :goods_id, ID, required: true

  field :goods, Types::Goods::GoodsType, null: true
  field :message, String, null: true
  field :errors, [ String ], null: false

  def resolve(goods_input:, goods_id:)
    service = ::GoodsServices::UpdateGoodsServices.new(goods_id, goods_input.to_h).execute

    if service.success?
      { goods: service.goods, message: "Successfully updated a product.", errors: [] }
    else
      { goods: nil, message: nil, errors: service.errors }
    end
  end
end
