class CartsController < ApplicationController
  before_action :set_q_ransack, only: [:index]
  # before_action :set_cart_num, only: [:index]

  def index
    if user_signed_in?
      @cart = current_user.cart
      @cart_products = @cart.cart_products.includes(sale_info: [:product])
    elsif session[:_cart_].present?
      @cart = Cart.find(session[:_cart_])
      @cart_products = @cart.cart_products.includes(sale_info: [:product])
    else
      @cart
    end
  end
end
