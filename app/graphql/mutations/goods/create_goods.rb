class ::Mutations::Goods::CreateGoods < Mutations::BaseMutation
  argument :goods_input, Types::InputObject::GoodsInputType, required: true

  field :goods, Types::Goods::GoodsType, null: true
  field :message, String, null: true
  field :errors, [ String ], null: false

  def resolve(goods_input:)
    debugger
    service = ::GoodsServices::CreateGoodsServices.new(goods_input.to_h).execute

    if service.success?
      { goods: service.goods, message: "Successfully created a product.", errors: [] }
    else
      { goods: nil, message: nil, errors: service.errors }
    end
  end
end
