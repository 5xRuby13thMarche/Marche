class ShopsController < ApplicationController
  layout "backend"
  before_action :authenticate_user!
  before_action :set_shop, only: [:index, :edit, :update, :destroy]
  
  def index
    @shop_products = @shop.order_products.includes(product: :sale_infos).where(product: { shop_id: @shop.id }).order(created_at: :desc)
    @total_price = @shop_products.sum{|shop_product| (shop_product.each_price * shop_product.quantity) }
    @total_quantity = @shop_products.sum{|shop_product| shop_product.quantity}

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
  
  def edit
  end

  def update
    if @shop.update(shop_params)
      redirect_to shops_path, notice: "賣場介紹已更新" 
    else
      render :edit, status: :unprocessable_entity 
    end
  end
  
  private
  def shop_params
    params.require(:shop).permit(:name, :image, :description)
  end

  def set_shop
    @shop = current_user.shop
  end
  

end
