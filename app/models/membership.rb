class Membership < ApplicationRecord
  # belongs_to :group
  acts_as_tenant(:group)
  belongs_to :user
end
