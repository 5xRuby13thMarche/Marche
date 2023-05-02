class Api::CartsController < ApplicationController

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
  
end
