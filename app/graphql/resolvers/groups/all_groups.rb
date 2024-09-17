class Resolvers::Groups::AllGroups < Resolvers::BaseResolver
  type Types::Groups::GroupReturnType, null: false

  def resolve
    authorize

    groups = Group.all
    if groups.present?
      groups.to_a
      { group: groups, message: "Successfully fetched all groups.", errors: [] }
    else
      { group: nil, message: nil, errors: [ "error: failed to fetch group" ] }
    end
  end
end
