class Customer < ApplicationRecord
  acts_as_tenant(:group)

  has_many :customer_branches, dependent: :destroy
  has_many :order_groups, dependent: :destroy
  has_many :delivery_order, dependent: :destroy

  validates :email, presence: true, uniqueness: { scope: :group_id }, format: { with: Devise.email_regexp }
  validates :phone, presence: true, numericality: true, length: { is: 10 }, uniqueness: { scope: :group_id }
  validates :email, format: { with: Devise.email_regexp }
  validates :name, presence: true, length: { minimum: 3 }
  validates :address, presence: true
end
