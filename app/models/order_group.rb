class OrderGroup < ApplicationRecord
  acts_as_tenant(:group)
  belongs_to :customer
  belongs_to :customer_branch
  belongs_to :parent_order_group, class_name: "OrderGroup", optional: true

  has_one :delivery_order, dependent: :destroy
  has_many :line_items, through: :delivery_order
  has_many :child_order_groups, class_name: "OrderGroup", foreign_key: "parent_order_group_id", dependent: :destroy


  validates :group, :customer, :customer_branch, presence: true
  validates :recurring, inclusion: { in: [ true, false ] }
  validates :recurrence_frequency, inclusion: { in: [ "daily", "weekly", "monthly" ] }, if: :recurring
  validates :recurrence_frequency, :next_due_date, :recurrence_end_date, presence: true, if: :recurring
  validates :recurrence_end_date, presence: true, if: :recurring

  def active_recurring?
    recurring && next_due_date <= recurrence_end_date
  end
end
