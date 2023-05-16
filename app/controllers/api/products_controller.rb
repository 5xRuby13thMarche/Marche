class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:like, :unlike]
  before_action :check_user_signed_in!, only: [:like, :unlike]
  
  def like
    current_user.liked_products << @product
    render json: {signInState: "true"}
  end

  def unlike
    current_user.liked_products.destroy(@product)
    render json: {signInState: "true"}
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description)
  end

  def check_user_signed_in!
    render json: {signInState: "false", signInUrl: new_user_session_path} unless user_signed_in?
  end
end
