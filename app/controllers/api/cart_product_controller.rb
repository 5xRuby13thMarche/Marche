class Api::CartProductController < ApplicationController
  
  def sendToCart
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
      else
        # render :show  這邊還要修 
      end
    end
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end

end
