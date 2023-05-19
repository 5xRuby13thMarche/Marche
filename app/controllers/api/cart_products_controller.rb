class Api::CartProductsController < ApplicationController
  before_action :check_user_signed_in!, only: [:create, :update]

  def create
    cart_product = current_user.cart.cart_products.find_or_initialize_by(sale_info_id: params[:sale_info_id])
    if cart_product.persisted?
      cart_product.update(quantity: cart_product.quantity + params[:quantity].to_i)
      render json: {ok: 'update success!', signInState: 'true'}
    else
      cart_product.assign_attributes(cart_product_params)
      cart_product.cart = current_user.cart
      if cart_product.save
        render json: {ok: 'create success！', signInState: 'true'}
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
