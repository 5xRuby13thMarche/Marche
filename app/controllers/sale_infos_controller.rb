class SaleInfosController < ApplicationController
  layout "shop"

  before_action :authenticate_user!
  before_action :set_shop
  before_action :set_sale_info

  def edit
  end

  def update
    if @sale_info.update(sale_info_params)
      redirect_to products_shops_path, notice: "銷售規格已更新" 
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  private

  def set_shop
    @shop = current_user.shop
  end
  
  def set_sale_info
    @sale_info = SaleInfo.find(params[:id])
  end
  
  def sale_info_params
    params.require(:sale_info).permit(:spec, :price, :storage)
  end
end
