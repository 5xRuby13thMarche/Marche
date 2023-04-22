class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:like]
  def like
    # 未登入
    if user_signed_in? == false
      render json: {signInState: "false", signInUrl: new_user_session_path}
      return
    end
    # 已登入
    if current_user.like_product?(@product)
      current_user.liked_products.destroy(@product)
      render json: {signInState: "true", new_like_state: "dislike"}
    else
      current_user.liked_products << @product
      render json: {signInState: "true", new_like_state: "like"}
    end
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description)
  end
end
