class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q_ransack, only: [:index]
  before_action :set_user_cart_product_num, only: [:index]

  def index
    @cart = current_user.cart
    @cart_products = @cart.cart_products.includes(sale_info: [:product])
  end

  private

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end

  def set_user_cart_product_num
    if user_signed_in?
      @user_cart_product_num = current_user.cart.cart_products.count
    end
  end

end
