# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :register_user, mutation: Mutations::Users::RegisterUser
    field :login_user, mutation: Mutations::Users::LoginUser
    field :logout_user, mutation: Mutations::Users::LogoutUser
    field :create_customer, mutation: Mutations::Customer::CreateCustomer
    field :delete_customer, mutation: Mutations::Customer::DeleteCustomer
    field :update_customer, mutation: Mutations::Customer::UpdateCustomer
    field :add_customerBranch, mutation: Mutations::CustomerBranch::AddCustomerBranch
    field :delete_customerBranch, mutation: Mutations::CustomerBranch::DeleteCustomerBranch
    field :update_customerBranch, mutation: Mutations::CustomerBranch::UpdateCustomerBranch
  end
end
