class Product < ApplicationRecord
  validates :name, :category_id, presence: true

  belongs_to :shop
  belongs_to :category
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :product_likes, dependent: :destroy
  has_many :product_likers, through: :product_likes, source: :user
  has_many :product_comments, dependent: :destroy
  has_many :sale_infos, dependent: :destroy
  has_one :property, dependent: :destroy
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  
  accepts_nested_attributes_for :sale_infos, :property

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def self.products_max_price(products, order)
    products = products.left_outer_joins(:sale_infos)
                        .select('products.*, MAX(sale_infos.price) as max_price')
                        .group('products.id')
                        .order("max_price #{order}")
  end

  def price_range
    [self.sale_infos.minimum(:price).round, self.sale_infos.maximum(:price).round]
  end
end
