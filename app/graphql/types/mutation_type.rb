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

    # CUSTOMER MUTATIONS
    field :create_customer, mutation: Mutations::Customer::CreateCustomer
    field :delete_customer, mutation: Mutations::Customer::DeleteCustomer
    field :update_customer, mutation: Mutations::Customer::UpdateCustomer

    # CUSTOMER BRANCH MUTATIONS
    field :add_customerBranch, mutation: Mutations::CustomerBranch::AddCustomerBranch
    field :delete_customerBranch, mutation: Mutations::CustomerBranch::DeleteCustomerBranch
    field :update_customerBranch, mutation: Mutations::CustomerBranch::UpdateCustomerBranch

    # VEHICLES MUTATIONS
    field :create_vehicle, mutation: Mutations::Vehicles::CreateVehicle
    field :update_vehicle, mutation: Mutations::Vehicles::UpdateVehicle
    field :delete_vehicle, mutation: Mutations::Vehicles::DeleteVehicle

    # DRIVER MUTATIONS
    field :add_driver, mutation: Mutations::Driver::CreateDriver
    field :delete_driver, mutation: Mutations::Driver::DeleteDriver
    field :update_driver, mutation: Mutations::Driver::UpdateDriver

    # ORDER MUTATIONS
    field :create_order_group, mutation: Mutations::OrderGroups::CreateOrderGroup
    field :update_order_group, mutation: Mutations::OrderGroups::UpdateOrderGroup
    field :delete_order_group, mutation: Mutations::OrderGroups::DeleteOrderGroup

    #DELIVERY ORDER MUTATIONS
    field :create_delivery_order, mutation: Mutations::DeliveryOrder::CreateDeliveryOrder
    field :update_delivery_order, mutation: Mutations::DeliveryOrder::UpdateDeliveryOrder
  end
end
