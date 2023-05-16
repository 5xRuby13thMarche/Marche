class ShopsController < ApplicationController
  layout "shop"
  
  before_action :authenticate_user!
  before_action :set_shop
  
  def index
    @shop_products = @shop.order_products_infos
    @total_price = Shop.total_price(@shop_products)
    @total_quantity = Shop.total_quantity(@shop_products)
  end
  
  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to shops_path, notice: "您的賣場已建立" 
    else
      render :new, status: :unprocessable_entity 
    end
  end
  
  def edit
  end

  def update
    if @shop.update(shop_params)
      redirect_to shops_path, notice: "賣場介紹已更新" 
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def order
    @shop_orders = @shop.order_products_infos
  end
  
  def products
  end

  private
  def shop_params
    params.require(:shop).permit(:name, :image, :description)
  end

  def set_shop
    @shop = current_user.shop
  end
end
