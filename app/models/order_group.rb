class OrderGroup < ApplicationRecord
  belongs_to :group
  belongs_to :customer
  belongs_to :customer_branch
  has_many :line_items, dependent: :destroy

  validates :group, :customer, :customer_branch, presence: true
  validates :recurring, inclusion: { in: [ true, false ] }
  validates :recurrence_frequency, inclusion: { in: [ "daily", "weekly", "monthly" ] }, if: :recurring
  validates :recurrence_frequency, :next_due_date, :recurrence_end_date, presence: true, if: :recurring
  validates :recurrence_end_date, presence: true, if: :recurring

  def active_recurring?
    recurring && next_due_date <= recurrence_end_date
  end
end
