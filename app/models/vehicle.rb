class Vehicle < ApplicationRecord
  acts_as_tenant(:group)
  include Status

  validates :license_plate, presence: true, uniqueness: true
  validates :brand, :vehicle_type, :capacity, presence: true

  include Rails.application.routes.url_helpers


  # belongs_to :group
  has_many :delivery_orders

  has_many_attached :images
  def image_url
    if images.attached?
      images.map { |image| Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) }
    else
      []
    end
  end
end
