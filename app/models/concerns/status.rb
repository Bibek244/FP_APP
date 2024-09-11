module Status
  extend ActiveSupport::Concern
  included do
    enum status: { available: 0, in_use: 1, maintenance: 2 }


    validates :status, presence: true
  end
end
