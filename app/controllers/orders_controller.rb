class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @order = Order.new
    @cart_products = CartProduct.where(id: params[:cart_product]).includes(:sale_info)

    total_price = 0
    total_price.floor
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
      redirect_to order_show_path(@order.id), notice: "產生訂單成功"
    else
      redirect_to :back, alert: "訂單成立失敗"
    end
  end 

  def show
    @order = Order.find(params[:id])
    @user = @order.user
    # 判斷是否登入
    if user_signed_in? == false
      sign_in @user   #勿動
    end

    if @order.payment_status == "pending"

      order_products = @order.order_products
      @form_info = Newebpay::Mpg.new(
        {MerchantOrderNo: @order.tracking_number,
         Amt: @order.total_price.to_i,
         ItemDesc: generate_item_desc(order_products),
         Email: @order.user.email}
        ).form_info
    end
  end
    
  def notify
    @response = Newebpay::MpgResponse.new(params[:TradeInfo])
  
    if @response.success?

      @order = Order.find_by(tracking_number: @response.order_no) #這裡的value在依訂單修改
      @order.payment_status = "paid" 
      @order.save
      redirect_to order_show_path(@order.id), notice: "交易完成"
    else
      redirect_to order_show_path(@order.id), alert: "交易失敗"
    end
  end
  
  private 
  def generate_tracking_number
    "#{Time.now.strftime("%Y%m%d%H%M%S")}#{SecureRandom.base36(6)}"
  end

  def generate_item_desc(order_products)
    order_products.pluck(:spec).reduce{|acc, cur| acc+cur}
  end
end
