class OrderGroup < ApplicationRecord
  acts_as_tenant(:group)
  acts_as_paranoid

  belongs_to :customer, -> { with_deleted }
  belongs_to :customer_branch, -> { with_deleted }
  belongs_to :parent_order_group, class_name: "OrderGroup", optional: true

  has_one :delivery_order, dependent: :destroy
  has_many :line_items, through: :delivery_order
  has_many :child_order_groups, class_name: "OrderGroup", foreign_key: "parent_order_group_id", dependent: :destroy


  validates :group, :customer, :customer_branch, presence: true
  validates :recurrence_frequency, inclusion: { in: [ "daily", "weekly", "monthly" ] }, if: :recurring
  validates :recurrence_frequency, :next_due_date, :recurrence_end_date, presence: true, if: :recurring

  before_destroy :delete_child_order_groups_with_pending_or_canceled_delivery_order, if: :has_child?
  private

  def has_child?
    child_order_groups.exists?
  end

  def delete_child_order_groups_with_pending_or_canceled_delivery_order
    child_order_groups.each do |child_order_group|
      status = child_order_group.delivery_order&.status
      if status == "pending" || status == "canceled"
        child_order_group.destroy
      end
    end
  end
end
