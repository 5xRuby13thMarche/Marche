class Shop < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :order_products, through: :products
  has_one_attached :logo

  def self.total_price(shop_products)
    shop_products.sum{|shop_product| (shop_product.each_price * shop_product.quantity) }
  end
  
  def self.total_quantity(shop_products)
    shop_products.sum{|shop_product| (shop_product.quantity) }
  end

  def shop_products_infos
    products.includes(:sale_infos, :order_products).order(created_at: :desc)
  end

  def order_products_infos
    order_products.includes(product: :sale_infos).where(product: { shop: self }).order(created_at: :desc)
  end
  
  def total_sales
    order_products_infos = self.order_products.includes(product: :sale_infos).where(product: { shop: self }).order(created_at: :desc)
    order_products_infos.group_by(&:spec).transform_values { |products| products.sum(&:quantity) }
  end
end
