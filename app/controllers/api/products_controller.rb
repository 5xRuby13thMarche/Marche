class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:like, :dislike]
  before_action :user_not_signed_in, only: [:like, :dislike]
  
  def like
    current_user.liked_products << @product
    render json: {signInState: "true"}
  end

  def dislike
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

  def user_not_signed_in
    render json: {signInState: "false", signInUrl: new_user_session_path} if user_signed_in? == false
  end
end
