# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject

    field :create_goods, mutation: Mutations::Goods::CreateGoods
    field :register_user, mutation: Mutations::Users::RegisterUser
    field :login_user, mutation: Mutations::Users::LoginUser

  end
end
