module Status
  extend ActiveSupport::Concern
  included do
    enum status: { available: "AVILABLE", in_use: "IN_USE", maintenance: "MAINTENANCE" }


    validates :status, presence: true
  end
end
