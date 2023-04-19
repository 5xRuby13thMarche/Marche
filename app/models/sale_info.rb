class SaleInfo < ApplicationRecord
  belongs_to :product, optional: true
  has_many :cart_products
  has_many :carts, through: :cart_products
end
