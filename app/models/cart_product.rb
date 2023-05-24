class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :sale_info

  def self.cal_total_price(cart_products)
    cart_products.reduce(0) {|acc, cur| acc += cur.quantity * cur.sale_info.price}
  end

  def self.update_or_create_cart_product(user, session_cart_id, params)
    if user.present?
      message = create_or_update_cart_product(user.cart, params)
    else
      message = create_or_update_cart_product(Cart.find(session_cart_id), params)
    end
  end

  def self.check_storage(cart_products)
    cart_products.each do |cart_product|
      return false if cart_product.sale_info.storage < cart_product.quantity || cart_product.sale_info.storage == 0
    end
    return true
  end

  def self.reduce_storage(cart_products)
    cart_products.each do |cart_product|
      storage = cart_product.sale_info.storage -= cart_product.quantity
      storage = (storage >=0 ) ? storage : 0
      cart_product.sale_info.update(storage: storage)
    end
  end

  private

  def self.create_or_update_cart_product(cart, params)
    cart_product = cart.cart_products.find_by(sale_info_id: params[:sale_info_id])
    if cart_product.nil?
      CartProduct.create(quantity: params[:quantity], sale_info_id: params[:sale_info_id], cart: cart)
      return {ok: 'create success！'}
    else
      cart_product.update(quantity: cart_product.quantity + params[:quantity].to_i)
      return {ok: 'update success!'}
    end
  end

end
