class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @order = Order.new
    @order.tracking_number = "#{current_user.id}-#{Time.now.strftime("%Y%m%d%H%M%S")}"
    @order.payment_status = "pending"
    @order.user_id = current_user.id

    sum = 0
    @cart_products = CartProduct.where(id: params[:cart_product]).includes(:sale_info)
    @cart_products.each do |c|
      # 算總價
      sum += c.quantity * c.sale_info.price
      @order.total_price = sum
      # 製作order_product
      @order.order_products.build(product_id: c.sale_info.product_id, 
                                  quantity: c.quantity,
                                  each_price: c.sale_info.price,
                                  spec: c.sale_info.spec)
    end

      if @order.save
        @form_info = Newebpay::Mpg.new.form_info
        p "="*50
        p @form_info
        p "="*50
        redirect_to orders_path
      else
        redirect_to :back, alert: "訂單成立失敗"
      end
  end 
    
  def index 
    @form_info = Newebpay::Mpg.new.form_info
    p "="*50
    p @form_info
    p "="*50
  end
    
  def notify
    @response = Newebpay::MpgResponse.new(params[:TradeInfo])
  
    if @response.success?
  
      @order = Order.find_by(tracking_number: params[:id]) #這裡的value在依訂單修改
        @order.payment_status = "Paid!" 
      @order.save
  
      redirect_to hello_path(@order.id), notice: "交易完成"
    else
      @user = User.find(1)  #強制登入，後方參數依照訂單更改
      sign_in @user  #勿動
      redirect_to checkout_path, notice: "交易失敗"
    end
  end
  
  def hello
    @order = Order.find(params[:id])  
    @user = User.find(1)  #強制登入，後方參數依照訂單更改
    sign_in @user   #勿動
  end
  
end
