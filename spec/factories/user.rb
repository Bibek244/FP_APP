FactoryBot.define do
  factory :user do
    email { "abc@mail.com" }
    password { "test@password" }
    password_confirmation { "test@password" }
    association :group
  end
end
