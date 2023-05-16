class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :sale_info

  def self.cal_total_price(cart_products)
    cart_products.reduce(0) {|acc, cur| acc += cur.quantity * cur.sale_info.price}
  end
end
