class CartsController < ApplicationController
  def index
    @cart = current_user.cart
    @cart_products = @cart.cart_products
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

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end

end
