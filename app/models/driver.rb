class Driver < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum status: { available: 0, unavailable: 1 }
end
