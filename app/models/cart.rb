class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_products, dependent: :destroy
  has_many :sale_infos, through: :cart_products

  # 轉移購物車內的商品到另外一台購物車
  def transfer_cart_products(other_cart_products)
    other_cart_products.each do |cart_product|
      found_cart_product = self.cart_products.find_by(sale_info_id: cart_product.sale_info_id)
      if found_cart_product.present?
        found_cart_product.update(quantity: found_cart_product.quantity + cart_product.quantity)
        cart_product.destroy()
      else
        cart_product.update(cart_id: self.id)
      end
    end
  end
end
