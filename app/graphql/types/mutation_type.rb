# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :register_user, mutation: Mutations::Users::RegisterUser
    field :login_user, mutation: Mutations::Users::LoginUser
    field :add_driver, mutation: Mutations::Driver::CreateDriver
    field :delete_driver, mutation: Mutations::Driver::DeleteDriver
    field :update_driver, mutation: Mutations::Driver::UpdateDriver
  end
end
