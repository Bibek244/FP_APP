class ::Mutations::Goods::CreateGoods < Mutations::BaseMutation
  argument :goods_input, Types::Goods::GoodsInputType, required: true

  type Types::Goods::GoodsResultType, null: false

  def resolve(goods_input:)
    authorize
    current_user = context[:current_user]
    service = ::GoodsServices::CreateGoodsServices.new(goods_input.to_h, current_user).execute

    if service.success?
      { goods: [ service.goods ], message: "Successfully created a product.", errors: [] }
    else
      { goods: nil, message: nil, errors: [ service.errors ] }
    end
  end
end
