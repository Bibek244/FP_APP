class Driver < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum status: { AVAILABLE: 0, UNAVAILABLE: 1, DEPLOYED: 2 }
  validates :email, presence: true, uniqueness: { scope: :group_id }
  validates :phone_no, presence: true, uniqueness: { scope: :group_id }
  validates :name, presence: true
  validates :address, presence: true
end
