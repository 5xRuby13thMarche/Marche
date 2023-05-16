class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:notify, :paid]
  before_action :set_q_ransack, only: [:new]
  before_action :set_user_cart_product_num, only: [:new]
  skip_before_action :verify_authenticity_token

  def new
    @cart = current_user.cart
    @cart_products =  @cart.cart_products.includes(sale_info: [:product]).where(id: params[:cart_product_ids])
    if @cart_products.count == 0
      redirect_to carts_path, alert: '請先選擇商品'
    end
    @order = Order.new
  end

  def create
    @order = Order.new
    @cart_products = CartProduct.where(id: params[:cart_product]).includes(:sale_info)
    
    total_price = 0
    @cart_products.each do |c|
      # 算總價
      total_price += c.quantity * c.sale_info.price
      # 製作order_products
      @order.order_products.build(product_id: c.sale_info.product_id, 
                                  quantity: c.quantity,
                                  each_price: c.sale_info.price,
                                  spec: c.sale_info.spec)
    end

    @order.tracking_number = generate_tracking_number()
    @order.payment_status = "pending"
    @order.user_id = current_user.id
    @order.total_price = total_price
    @order.shipping_address = params[:order][:shipping_address]
    @order.shipping_status = params[:order][:shipping_status]
    @order.receiver = params[:order][:receiver]
    @order.note = params[:order][:note]

    if @order.save
      redirect_to order_path(@order.id), notice: "產生訂單成功"
    else
      redirect_to :back, alert: "訂單成立失敗"
    end
  end 

  def show
    @order = Order.find(params[:id])
    order_products = @order.order_products
    @form_info = Newebpay::Mpg.new(
      {MerchantOrderNo: @order.tracking_number,
        Amt: @order.total_price.to_i,
        ItemDesc: generate_item_desc(order_products),
        Email: @order.user.email}
      ).form_info
  end
    
  def notify
    @response = Newebpay::MpgResponse.new(params[:TradeInfo])
    @order = Order.find_by(tracking_number: @response.order_no) #這裡的value在依訂單修改
    
    if @response.success?
      @order.payment_status = "paid" 
      @order.save
      redirect_to order_paid_path(@order.id), notice: "交易完成"
    else
      redirect_to order_paid_path(@order.id), alert: "交易失敗"
    end
  end

  def paid
    @order = Order.find(params[:id])
    @user = @order.user
    if user_signed_in? == false
      sign_in @user 
    end
  end

  #買家訂單
  def index
    @orders = current_user.orders.includes(order_products: [:product])
  end
  
  #賣家訂單
  def shop_order
    @shop = current_user.shop
    @shop_products = @shop.order_products.includes(product: :sale_infos).where(product: { shop_id: @shop.id }).order(created_at: :desc)
    render layout: 'backend'
  end

  private
  
  def set_q_ransack
    @ransack_q = Product.ransack(params[:q])
  end

  def set_user_cart_product_num
    if user_signed_in?
      @user_cart_product_num = current_user.cart.cart_products.count
    end
  end

  def generate_tracking_number
    "#{Time.now.strftime("%Y%m%d%H%M%S")}#{SecureRandom.base36(6)}"
  end

  def generate_item_desc(order_products)
    order_products.pluck(:spec).reduce{|acc, cur| acc+cur}
  end


end
