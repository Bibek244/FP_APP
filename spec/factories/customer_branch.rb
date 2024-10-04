FactoryBot.define do
  factory :customer_branch do
    branch_location { "Kathmandu" }
    association :customer
    association :group
  end
end
