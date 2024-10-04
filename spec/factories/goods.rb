FactoryBot.define do
  factory :goods do
    name { "Sample Product" }
    sold_as { "Each" }
    unit { "liter" }
    availability { "IN_STOCK" }
    association :category
    association :group
  end
end
