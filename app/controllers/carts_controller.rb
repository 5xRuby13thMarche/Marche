class CartsController < ApplicationController
  before_action :authenticate_user!
  def index
    @cart = current_user.cart
    @cart_products = @cart.cart_products.includes(sale_info: [:product])
  end
  
  def create
    @cart_product = CartProduct.new(cart_product_params)
    @cart_product.cart_id = current_user.cart.id

    
    if @cart_product.save
      redirect_to cart_path, notice: "Product added to cart successfully!"
    else
      # render :show  這邊還要修 
    end
  end

  def checkout
    @cart = current_user.cart
    cart_items_keys = params[:cart].delete_if{|key, value| value == '0'}.keys
    @cart_products =  @cart.cart_products.includes(sale_info: [:product]).where(id: cart_items_keys)
  end

  def destroy
    @cart_product = CartProduct.find(params[:id])
    @cart_product.destroy()
    redirect_to cart_path, notice: "已刪除商品"
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end

end
