class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from AbstractController::ActionNotFound, with: :render_404
  rescue_from StandardError, with: :render_500  

  include Pagy::Backend

  def set_cart_num
    if user_signed_in?
      @user_cart_product_num = current_user.cart.cart_products.count
    elsif session[:_cart_].present?
      @user_cart_product_num = Cart.find(session[:_cart_]).cart_products.count
    end
  end

  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end
  
  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join('public', '404.html'), layout: 'layouts/application', status: 404 }
      format.all { render plain: '404 Not Found', status: 404 }
    end
  end

  def render_500
    respond_to do |format|
      format.html { render file: Rails.root.join('public', '500.html'), layout: 'layouts/application', status: 500 }
      format.all { render plain: '500 Internal Server Error', status: 500 }
    end
  end

  def record_recent_path
    session[:_prev_path_] = request.fullpath
  end
end
