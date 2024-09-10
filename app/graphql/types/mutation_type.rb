# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # GOODS MUTATAIONS
    field :create_goods, mutation: Mutations::Goods::CreateGoods
    field :update_goods, mutation: Mutations::Goods::UpdateGoods
    field :delete_goods, mutation: Mutations::Goods::DeleteGoods

    # LOGIN AND REGISTRAGTION MUTATIONS
    field :register_user, mutation: Mutations::Users::RegisterUser
    field :login_user, mutation: Mutations::Users::LoginUser

    # VEHICLES MUTATIONS
    field :create_vehicle, mutation: Mutations::Vehicles::CreateVehicle
    field :update_vehicle, mutation: Mutations::Vehicles::UpdateVehicle
    field :delete_vehicle, mutation: Mutations::Vehicles::DeleteVehicle
  end
end
