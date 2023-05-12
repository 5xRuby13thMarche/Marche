class ShopsController < ApplicationController
  layout "backend"
  before_action :authenticate_user!
  
  def  index
    @shop = Shop.find_by(user_id: current_user.id)
  end
  
  def new
    @shop = Shop.new
  end
  
  def create
    @shop = Shop.new(shop_params)
    @shop.user_id = current_user.id
    if @shop.save
      redirect_to shops_path, notice: "您的賣場已建立" 
    else
      render :new, status: :unprocessable_entity 
    end
  end


  private
  def shop_params
    params.require(:shop).permit(:name, :image, :description)
  end


end
