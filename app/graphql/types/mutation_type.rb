# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_goods, mutation: Mutations::Goods::CreateGoods
    field :update_goods, mutation: Mutations::Goods::UpdateGoods
    field :delete_goods, mutation: Mutations::Goods::DeleteGoods
  end
end
