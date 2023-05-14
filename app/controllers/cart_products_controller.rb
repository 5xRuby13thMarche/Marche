class CartProductsController < ApplicationController
  def destroy
    @cart_product = CartProduct.find(params[:id])
    @cart_product.destroy()
  end
end
