# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # GOODS MUTATAIONS
    field :create_goods, mutation: Mutations::Goods::CreateGoods
    field :update_goods, mutation: Mutations::Goods::UpdateGoods

    # LOGIN AND REGISTRAGTION MUTATIONS
    field :register_user, mutation: Mutations::Users::RegisterUser
    field :login_user, mutation: Mutations::Users::LoginUser
  end
end
