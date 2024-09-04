# frozen_string_literal: true

module Mutations
  module Users
    class RegisterUser < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :group_id, ID, required: true

      field :user, Types::UserType, null: true
      field :error, [ String ],  null: true
      field :message, String, null: true


      def resolve(email:, password:, password_confirmation:, group_id:)
        group = Group.find(group_id)
        if group.present?
          # debugger
          # user = User.create(email: email, password: password, password_confirmation: password_confirmation)
          user = User.new(email: email, password: password, password_confirmation: password_confirmation)

          if user.save
            membership = Membership.new(user_id: user.id, group_id: group_id)
            if membership.save
              {
                user: user,
                message: "Registration Sucessfull",
                error: nil
              }
            else
              user.destroy
              {
                user: nil,
                message: "Registration failed. Membership cannot be created",
                error: membership.errors.full_messages
              }
            end
          else
            {
              user: nil,
              message: "Registration failed. User cannot be created",
              error: user.errors.full_messages
            }
          end
        else
          {
            user: nil,
            message: "Organization doesnot exist",
            error: user.errors.full_messages
          }
        end
      end
    end
  end
end
