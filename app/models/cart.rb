class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_products
  has_many :sale_infos, through: :cart_products
  has_many :products, through: :cart_products
end
