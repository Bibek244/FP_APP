module Types
  module Goods
    class GoodsResultType < Types::BaseObject
      field :goods, [ Types::Goods::GoodsType ], null: true
      field :message, String, null: true
      field :errors, [ String ], null: false
    end
  end
end
