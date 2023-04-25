class CartsController < ApplicationController
  def new
    @cart = current_user.cart
    @cart_products = @cart.cart_products
  end
  
  def create
    @cart = Cart.new(user: current_user)
    if @cart.save
      redirect_to @cart, notice: '購物車已建立'
    else
      redirect_to root_path, alert: '建立購物車失敗'
    end
  end
end
