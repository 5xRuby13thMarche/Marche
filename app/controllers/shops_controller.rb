class ShopsController < ApplicationController
  layout "shop", except: [:show]
  before_action :set_q_ransack, only: [:show]
  before_action :set_cart_num, only: [:show]
  before_action :authenticate_user!
  before_action :set_shop, expect: [:show]
  before_action :record_recent_path, only: [:show]
  
  def index
    @shop_products = @shop.order_products_infos
    @shipped_product = @shop.shipped_order_products
    @total_price = Shop.total_price(@shop_products)
    @total_quantity = Shop.total_quantity(@shop_products)
    
    case params[:chart]
    when 'total_price'
      @chart = @shop.total_price_by_day
    when 'top_products'
      @chart = @shop.top_of_products(5)
    when 'total_order'
      @chart = @shop.order_product_by_day
    end
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

  def show
    @shop = Shop.find(params[:id])
    @products = Product.where(shop_id: params[:id]).includes(:category).order(created_at: :desc)
    @sub_categories = Product.where(shop_id: params[:id]).includes(:category).pluck(:category_id ,:content).uniq
   
    if params[:category].present?
      @products = @products.where(category_id: params[:category]).order(created_at: :desc)
    end

    case params[:sort]
      when 'new'
        @products = @products.order(created_at: :desc)
      when 'price_high'
        @products = @products.products_max_price(@products, "DESC")
      when 'price_low'
        @products = @products.products_max_price(@products, "ASC")
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
    @shop_orders = @shop.order_products_infos.where(shipping_status: 'not_shipped').order(created_at: :desc)
  end

  def shipped
    @shop_orders = @shop.order_products_infos.where(shipping_status: 'shipped').order(updated_at: :desc)
  end

  def products
  end

  private
  def shop_params
    params.require(:shop).permit(:name, :logo, :description)
  end

  def set_shop
    @shop = current_user.shop
  end
end
