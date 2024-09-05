# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # product or goods mutations
    field :create_goods, mutation: Mutations::Goods::CreateGoods
    field :update_goods, mutation: Mutations::Goods::UpdateGoods

    # user registrations and login mutations
    field :register_user, mutation: Mutations::Users::RegisterUser
    field :login_user, mutation: Mutations::Users::LoginUser
  end
end
