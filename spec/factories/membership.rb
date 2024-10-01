FactoryBot.define do
  factory :membership do
    association :group
    association :user
  end
end
