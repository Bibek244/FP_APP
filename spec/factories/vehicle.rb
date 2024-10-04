FactoryBot.define do
  factory :vehicle do
    license_plate { "123456789" }
    brand { "Mahendra" }
    model { "Heavy Truck" }
    vehicle_type { "Truck" }
    status { "available" }
    capacity { 15000 }
  end
end
