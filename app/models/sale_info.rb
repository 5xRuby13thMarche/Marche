class SaleInfo < ApplicationRecord
  validates :price, :storage, :spec, presence: true

  belongs_to :product, optional: true
  has_many :cart_products
  has_many :carts, through: :cart_products
end
