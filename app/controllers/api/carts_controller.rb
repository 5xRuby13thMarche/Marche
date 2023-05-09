class Api::CartsController < ApplicationController
  # 購物車內商品數量的增減
  def edit
    @cart_product = CartProduct.find(params[:id])
    storage = @cart_product.sale_info.storage
    if params[:quantity] < 0 || params[:quantity] > storage 
      render json: {state: "fail"}
      return
    else
      @cart_product.quantity = params[:quantity]
      @cart_product.save
      render json: {state: "success"}
    end
  end

  # 清空購物車所屬的所有products
  def destroy_items
    cart = Cart.find(params[:cart_id])
    cart.cart_products.destroy_all
    render json: {state: "success"}
  end
  
end
