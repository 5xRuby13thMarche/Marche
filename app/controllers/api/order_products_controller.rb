class Api::OrderProductsController < ApplicationController
  before_action :check_user_signed_in!, only: [:update]

  def update
    order_product = OrderProduct.find(params[:id])
    if order_product.shipping_status == "not_shipped"
      order_product.update(shipping_status: params[:shipping])
      render json: {ok: 'shipped！', signInState: 'true'}
    else
      render json: {ok: 'product is already shipped！', signInState: 'true'}
    end
  
  end

  private

  def order_product_params
    params.require(:order_product).permit(:shipping)
  end

  def check_user_signed_in!
    render json: {signInState: "false", signInUrl: new_user_session_path} unless user_signed_in?
  end
end
