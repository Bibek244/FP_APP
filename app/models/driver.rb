class Driver < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum status: { AVAILABLE: 0, UNAVAILABLE: 1, DEPLOYED: 2 }
  validates :email, presence: true
  validates :email, uniqueness: { scope: :group_id }
  validates :phone_no, uniqueness: { scope: :group_id }
end
