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
  { email: "zzz@mail.com", password: "zzz@mail.com", group_id: 1 },
  { email: "xxx@mail.com", password: "xxx@mail.com", group_id: 2 }
]
user_data.each do |user|
  created_user = User.find_or_create_by(email: user[:email]) do |u|
    u.password = user[:password]
    u.group_id = user[:group_id]
  end

  # Find the group by id
  group = Group.find_by(id: user[:group_id])
  next unless group # Skip if the group is not found

  # Create the membership
  Membership.find_or_create_by(user_id: created_user.id, group_id: created_user.group.id) 
end
