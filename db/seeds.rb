# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

group = [
  { name: "XYZ" },
  { name: "ABC" }
]

group.each do |grp|
  Group.find_or_create_by(name: grp[:name])
end


user_data = [
  { email: "zzz@mail.com", password: "zzz@mail.com", group_name: "XYZ" }
]

user_data.each do |user|
  created_user = User.find_or_create_by(email: user[:email]) do |u|
    u.password = user[:password]
  end

  # Find the group by name
  group = Group.find_by(name: user[:group_name])
  next unless group # Skip if the group is not found

  # Create the membership
  Membership.find_or_create_by(user_id: created_user.id, group_id: group.id)
end
