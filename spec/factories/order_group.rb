# FactoryBot.define do
#   factory :order_group do
#     planned_at { Date.today + 1 }
#     recurring { false }
#     recurrence_frequency { nil }
#     recurrence_end_date { nil }
#     association :group
#     association :customer_branch

#     after(:create) do |order_group, evaluator|
#       create(:delivery_order, order_group: order_group, dispatched_date: order_group.planned_at)
#     end
#   end

#   factory :delivery_order do
#     association :driver
#     association :vehicle
#     status { 'PENDING' }
#     association :order_group
#     dispatched_date { order_group.planned_at }
#     delivery_date { nil }
#     association :customer
#     association :group
#     association :customer_branch

#     after(:create) do |delivery_order, evaluator|
#       create_list(:line_item, 2, delivery_order: delivery_order)
#     end
#   end

#   factory :line_item do
#     association :goods
#     quantity { 10 }
#     unit { 'LITERS' }
#     delivery_order
#   end
# end

FactoryBot.define do
  factory :order_group do
    planned_at { Date.today + 1 }
    recurring { false }
    recurrence_frequency { nil }
    recurrence_end_date { nil }
    association :group
    association :customer
    association :customer_branch

    after(:create) do |order_group, evaluator|
      driver = Driver.first
      vehicle = Vehicle.first
      goods = Goods.first
      delivery_order = create(:delivery_order, group: order_group.group, order_group: order_group, driver_id: driver.id, vehicle_id: vehicle.id)

      create(:line_item, delivery_order: delivery_order, goods_id: goods.id)
    end
  end

  factory :delivery_order do
    association :driver
    association :vehicle
    status { 'PENDING' }
    association :customer
    association :customer_branch
    association :group
  end

  factory :line_item do
    association :goods
    quantity { 10 }
    unit { 'liters' }
    association :delivery_order
  end
end
