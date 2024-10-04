FactoryBot.define do
  factory :customer do
    name { "Test" }
    phone { "9841000000" }
    email { "test@test.com" }
    address { "Nepal" }
    association :group
  end
end
