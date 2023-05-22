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
    order_products.includes(product: :sale_infos).where(product: { shop: self })
  end
  
  def total_sales
    order_products_infos = self.order_products.includes(product: :sale_infos).where(product: { shop: self }).order(created_at: :desc)
    order_products_infos.group_by(&:spec).transform_values { |products| products.sum(&:quantity) }
  end

  def order_product_by_day
    order_products.group_by_day(:created_at).count
  end

  def total_price_by_day
    order_products.group_by_day(:created_at).sum('quantity * each_price')
  end

  def top_of_products(limit)
    order_products.joins(:product).group('products.name').order('sum_quantity DESC').limit(limit).sum(:quantity)
  end
 
  def shipped_order_products
    order_products.where('"order_products"."created_at" != "order_products"."updated_at"')
  end
end
