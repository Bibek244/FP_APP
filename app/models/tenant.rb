class Tenant < ApplicationRecord
has_many :customers
has_many :products
has_many :assets
end
