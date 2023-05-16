class Api::CartProductsController < ApplicationController
  before_action :check_user_signed_in!, only: [:like, :dislike]

  def create
    update_cart_product = current_user.cart.cart_products.find_by(sale_info_id: params[:sale_info_id])
    if update_cart_product
      update_quantity = update_cart_product.quantity + params[:quantity]
      update_cart_product.update(quantity: update_quantity)
      render json: {ok: 'update'}
    else
      cart_product = CartProduct.new(cart_product_params)
      cart_product.cart_id = current_user.cart.id
      if cart_product.save
        render json: {ok: '加入購物車成功！'}
      end
    end
  end

  # 購物車內商品數量的增減
  def update
    cart_product = CartProduct.find(params[:id])
    storage = cart_product.sale_info.storage
    if params[:quantity] < 0 || params[:quantity] > storage 
      render json: {state: "fail"}
      return
    else
      cart_product.quantity = params[:quantity]
      cart_product.save
      render json: {state: "success"}
    end
  end

  # 清空購物車所屬的所有products
  def delete_all
    cart = Cart.find(params[:cart_id])
    cart.cart_products.destroy_all
    render json: {state: "success"}
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end

  def check_user_signed_in!
    render json: {signInState: "false", signInUrl: new_user_session_path} unless user_signed_in?
  end
end
