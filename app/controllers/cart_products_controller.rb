class CartProductsController < ApplicationController
  def create
    @sale_info = SaleInfo.find(params[:cart_product][:sale_info_id])
    @cart_product = current_user.cart.cart_products.new(cart_product_params)

    if @cart_product.save
      redirect_to root_path, notice: "Product added to cart successfully!"
    else
      render :show
    end
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:quantity, :sale_info_id)
  end
end