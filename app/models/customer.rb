class Customer < ApplicationRecord
  acts_as_tenant(:group)

  has_many :customer_branches, dependent: :destroy
  has_many :order_groups, dependent: :destroy
  has_many :delivery_order, dependent: :destroy

  validates :email, presence: true, uniqueness: { scope: :group_id }
  validates :phone, presence: true, uniqueness: { scope: :group_id }, length: { is: 10 }
  validates :email, format: { with: Devise.email_regexp }
  validates :name, presence: true, length: { minimum: 3 }
  validates :address, presence: true
end
