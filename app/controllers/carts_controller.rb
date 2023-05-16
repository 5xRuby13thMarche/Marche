class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q_ransack, only: [:index]
  before_action :set_cart_num, only: [:index]

  def index
    @cart = current_user.cart
    @cart_products = @cart.cart_products.includes(sale_info: [:product])
  end
end
