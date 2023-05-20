class Api::CartProductsController < ApplicationController

  def create
    if user_signed_in? || session[:_cart_].present?
      message = CartProduct.update_or_create_cart_product(current_user, session[:_cart_], params)
    else
      session_cart = Cart.create()
      session[:_cart_] =  session_cart.id
      session_cart.cart_products.create(quantity: 1, sale_info_id: params[:sale_info_id])
      message = {ok: 'create success！'}
    end
    render json: message
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
end
