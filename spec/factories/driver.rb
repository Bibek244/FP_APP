FactoryBot.define do
  factory :driver do
    name { "driver1" }
    email { "driver@mail.com" }
    phone_no { "9843888888" }
    address { "Lalitpur" }
    status { "AVAILABLE" }
    association :group
  end
end
