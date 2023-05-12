class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q_ransack, only: [:index, :checkout]
  def index
    @cart = current_user.cart
    @cart_products = @cart.cart_products.includes(sale_info: [:product])
  end
  
  def create
  end

  # order 
  def checkout
    @cart = current_user.cart
    @cart_products =  @cart.cart_products.includes(sale_info: [:product]).where(id: params[:cart_product_ids])
    @order = Order.new
  end

  # CartProductsControler
  def destroy
    @cart_product = CartProduct.find(params[:id])
    @cart_product.destroy()
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end

end
