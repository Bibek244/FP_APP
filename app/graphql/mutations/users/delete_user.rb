# frozen_string_literal: true

module Mutations
  module Users
    class DeleteUser < BaseMutation
      argument :user_id, ID, required: true

      field :user, Types::UserType, null: true
      field :error, [ String ],  null: true
      field :message, String, null: true

      def resolve(user_id:)
        debugger
        membership = Membership.find_by(user_id: user_id)
        membership.destroy
        user = User.find_by(id: user_id)
        if user.present?
          user.destroy
          {
            user: nil,
            message: "User destroyed",
            error: nil
          }
        end
      end
    end
  end
end
