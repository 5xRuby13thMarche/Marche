class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products
  has_many :products, through: :order_products
  validates :shipping_address, presence: true
  validates :receiver, presence: true
  extend FriendlyId
  friendly_id :tracking_number, use: :slugged


  def build_cart_products(cart_products)
    cart_products.each do |cart_product|
      self.order_products.build(product_id: cart_product.sale_info.product_id, 
                                  quantity: cart_product.quantity,
                                  each_price: cart_product.sale_info.price,
                                  spec: cart_product.sale_info.spec)
    end
  end

  def generate_tracking_number
    self.tracking_number = "#{Time.now.strftime("%Y%m%d%H%M%S")}#{SecureRandom.alphanumeric(6)}"
  end

  def self.generate_item_desc(order_products)
    order_products.pluck(:spec).reduce{|acc, cur| acc + cur}
  end

  def self.contain_user_orders?(orders, user)
    return orders.any? { |order| user.orders.include?(order) }
  end
  
end
