class Customer < ApplicationRecord
  acts_as_tenant(:group)
  acts_as_paranoid
  has_many :customer_branches
  has_many :order_groups
  has_many :delivery_order

  validates :email, presence: true, uniqueness: { scope: :group_id }, format: { with: Devise.email_regexp }
  validates :phone, presence: true, numericality: true, length: { is: 10 }, uniqueness: { scope: :group_id }
  validates :name, presence: true, length: { minimum: 3 }
  validates :address, presence: true

  before_destroy :delete_pending_order_groups
  before_destroy :soft_delete_customer_branches

  private

  def delete_pending_order_groups
    order_groups_to_delete = order_groups.joins(:delivery_order).where(delivery_order: { status: [ "pending", "cancelled" ] })
    order_groups_to_delete.destroy_all
  end

  def soft_delete_customer_branches
    customer_branches.destroy_all
  end

  scope :active, -> { where(deleted_at: nil) }
end
