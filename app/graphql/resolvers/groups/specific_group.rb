class Resolvers::Groups::SpecificGroup < Resolvers::BaseResolver
  type Types::Groups::GroupReturnType, null: false

  argument :id, ID, required: true

  def resolve(id:)
    group = Group.where(id: id)
    if group.present?
      group.to_a
      { group: group, message: "Successfully fetched the group.", errors: [] }
    else
      { group: nil, message: nil, errors: [ "error: failed to fetch group" ] }
    end
  end
end
