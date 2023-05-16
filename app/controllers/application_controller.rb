class ApplicationController < ActionController::Base
  include Pagy::Backend
  def set_cart_num
    if user_signed_in?
      @user_cart_product_num = current_user.cart.cart_products.count
    end
  end

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end
end
