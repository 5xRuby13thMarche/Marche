class Api::CartProductController < ApplicationController
  def sendToCart
    cart_product = CartProduct.new(cart_product_params)
    cart_product.cart_id = current_user.cart.id

    
    if cart_product.save
      render json: {ok: '加入購物車成功！'}
    else
      # render :show  這邊還要修 
    end
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end

end
