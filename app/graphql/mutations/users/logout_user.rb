class ::Mutations::Users::LogoutUser < Mutations::BaseMutation
  field :success, Boolean, null: true
  field :error, [ String ], null: true
  field :message, String, null: true

  def resolve
    authorize
    if user
      if user.jti == nil
        {
          success: false,
          error: [],
          message: "User is already logged out"
        }
      else
        invalid_jti = SecureRandom.uuid
        if user.update(jti: invalid_jti)
        {
          success: true,
          error: [],
          message: "Logged out successfully"
        }
        else
          {
            success: false,
            error: [ user.errors.full_messages ],
            message: "Logout Unsucessfull"
          }
        end
      end
    else
      {
        success: false,
        error: [],
        message: "No user Found"
      }
    end
  end

  private

  def user
    context[:current_user] # access the user in the context
  end
end
