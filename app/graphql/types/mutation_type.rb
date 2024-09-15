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

    field :create_customer, mutation: Mutations::Customer::CreateCustomer
    field :delete_customer, mutation: Mutations::Customer::DeleteCustomer
    field :update_customer, mutation: Mutations::Customer::UpdateCustomer
    field :add_customerBranch, mutation: Mutations::CustomerBranch::AddCustomerBranch
    field :delete_customerBranch, mutation: Mutations::CustomerBranch::DeleteCustomerBranch
    field :update_customerBranch, mutation: Mutations::CustomerBranch::UpdateCustomerBranch

    # VEHICLES MUTATIONS
    field :create_vehicle, mutation: Mutations::Vehicles::CreateVehicle
    field :update_vehicle, mutation: Mutations::Vehicles::UpdateVehicle
    field :delete_vehicle, mutation: Mutations::Vehicles::DeleteVehicle

    # ORDER MUTATIONS
    field :create_order_group, mutation: Mutations::OrderGroups::CreateOrderGroup
    field :update_order_group, mutation: Mutations::OrderGroups::UpdateOrderGroup
  end
end
