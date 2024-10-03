class CustomerBranch < ApplicationRecord
  acts_as_tenant(:group)
  acts_as_paranoid

  belongs_to :customer

  has_many :order_groups
  has_many :delivery_orders

  validates :branch_location, presence: true, uniqueness: { scope: :customer_id }

  private

  def delete_pending_order_groups
    order_groups_to_delete = order_groups.joins(:delivery_order).where(delivery_order: { status: [ "pending", "cancelled" ] })
    order_groups_to_delete.destroy_all
  end

  scope :active, -> { where(deleted_at: nil) }
end
