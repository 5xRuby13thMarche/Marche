class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:notify, :paid]
  before_action :set_q_ransack, only: [:new, :create, :index, :show, :search]
  before_action :set_cart_num, only: [:new, :index, :show, :search]
  before_action :record_recent_path, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:notify]  


  # 結帳頁面
  def new
    @cart = current_user.cart
    @cart_products =  @cart.cart_products.includes(sale_info: [:product]).where(id: params[:cart_product_ids])
    if @cart_products.count.zero?
      redirect_to carts_path, alert: '請先選擇商品'
    elsif !CartProduct.check_storage(@cart_products)
      redirect_to carts_path, alert: '商品數量超過庫存'
    end
    @order = Order.new
    @total_price = CartProduct.cal_total_price(@cart_products) # 算總價
  end

  def create
    @cart_products = CartProduct.where(id: params[:cart_product]).includes(:sale_info)
    total_price = CartProduct.cal_total_price(@cart_products) # 算總價
    @order = Order.new(order_params)
    @order.build_cart_products(@cart_products) # 製作order_products
    @order.generate_tracking_number()
    @order.user = current_user
    @order.total_price = total_price

    if CartProduct.check_storage(@cart_products) && @order.save
      CartProduct.reduce_storage(@cart_products)
      @cart_products.destroy_all # 購物車中減去訂單的商品
      redirect_to order_path(@order), notice: "訂單成立"
    else
      @total_price = CartProduct.cal_total_price(@cart_products) # 算總價
      render :new, status: :unprocessable_entity
    end
  end 

  def show
    @order = Order.friendly.find(params[:id])
    order_products = @order.order_products
    @form_info = Newebpay::Mpg.new(
      {MerchantOrderNo: @order.tracking_number,
        Amt: @order.total_price.to_i,
        ItemDesc: Order.generate_item_desc(order_products),
        Email: @order.user.email}
      ).form_info
  end
    
  def notify
    @response = Newebpay::MpgResponse.new(params[:TradeInfo])
    @order = Order.find_by(tracking_number: @response.order_no) #這裡的value在依訂單修改

    if @response.success?
      @order.update(payment_status: "paid" )
      redirect_to paid_order_path(@order), notice: "交易成功"
    else
      redirect_to paid_order_path(@order), alert: "交易失敗"
    end
  end

  def paid
    @order = Order.friendly.find(params[:id])
    sign_in @order.user unless user_signed_in?
    
    if @order.payment_status == "pending"
      @order.update(tracking_number: @order.generate_tracking_number() )
    end

    @form_info = Newebpay::Mpg.new(
      {MerchantOrderNo: @order.tracking_number,
        Amt: @order.total_price.to_i,
        ItemDesc: Order.generate_item_desc(@order.order_products),
        Email: @order.user.email}
      ).form_info

  end

  #會員所有訂單
  def index
    @orders = current_user.orders.includes(order_products: [:product]).order(created_at: :desc)
    @pagy, @orders = pagy(@orders, items: 6)
  end

  private

  def order_params
    params.require(:order).permit(:receiver, :shipping_status, :shipping_address, :note)
  end
end
