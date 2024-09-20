# frozen_string_literal: true

module Mutations
  module Users
    class LoginUser < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true
      argument :group_id, ID, required: true

      field :user, Types::UserType, null: true
      field :message, String, null: true
      field :error, [ String ], null: true
      field :token, String, null: true

      def resolve(email:, password:, group_id:)
        group = Group.find_by(id: group_id)

        # debugger
        if group.present?
          user = group.users.find_by(email: email)
          if user.present?
            if user.valid_password?(password)
            # token = JWT.encode({ user_id: user.id }, "secret", "HS256")
            jti = SecureRandom.uuid
            user.update(jti: jti)
            token = JWT.encode({ user_id: user.id, group_id: group_id, exp: 24.hour.from_now.to_i }, "secret", "HS256")
              {
                token: token,
                user: user,
                message: "Login Sucessfull",
                error: []
              }
            else
              {
                token: [],
                user: nil,
                message: "Incorrect Password",
                error: user.errors.full_messages
              }
            end
          else
            {
              token: [],
              user: nil,
              message: "User is not present in this organization",
              error: [ "User not present" ]
            }
          end
        else
          {
            token: [],
            user: nil,
            message: "Invalid Group",
            error: [ "Group is not found" ]
          }
        end
      end
    end
  end
end
