module Types
  module Groups
    class GroupReturnType < Types::BaseObject
      field :group, [ Types::Groups::GroupType ], null: true
      field :errors, [ String ], null: false
      field :message, String, null: true
    end
  end
end
