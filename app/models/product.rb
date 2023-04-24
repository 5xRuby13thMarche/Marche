class Product < ApplicationRecord
  belongs_to :shop, optional: true
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :sale_infos
  
  has_many :product_likes
  has_many :product_likers, through: :product_likes, source: :user, dependent: :destroy
end
